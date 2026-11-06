"""Offline bridge tests. No microphone, Ollama, Windows or game required."""
import sys
import io
import json
from unittest import mock
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from bridge_service import (load_json, save_json_atomic, validate_request,
                            handle_request, cli, local_chat, serve, REQUEST_NAME, RESPONSE_NAME, HISTORY_NAME)

REQ = {
    "schema": 1,
    "id": "demo-123",
    "npc_key": "game-npc-42",
    "npc_name": "Test NPC",
    "mode": "text",
    "player_line": "You remember me?",
    "reputation": -40,
    "disposition": "nemesis",
}


class TestOfflineVoice(unittest.TestCase):
    def test_validates_request(self):
        self.assertEqual(validate_request(REQ)["npc_key"], "game-npc-42")

    def test_rejects_bad_schema(self):
        with self.assertRaises(ValueError):
            validate_request({**REQ, "schema": 2})

    def test_rejects_oversize_line(self):
        with self.assertRaises(ValueError):
            validate_request({**REQ, "player_line": "A" * 1001})

    def test_rejects_empty_typed_line(self):
        with self.assertRaises(ValueError):
            validate_request({**REQ, "player_line": " "})

    def test_disk_atomic_roundtrip(self):
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder) / "voice_history.json"
            save_json_atomic(p, {"npc": [{"role": "user", "content": "hi"}]})
            self.assertEqual(load_json(p)["npc"][0]["content"], "hi")

    def test_text_turn_and_memory(self):
        mock_chat = lambda *args, **kwargs: "Of course I remember."
        response, history = handle_request(REQ, {}, model="fake", whisper_model="base",
                                           device="cpu", mic_seconds=1, enable_tts=False,
                                           chat_fn=mock_chat)
        self.assertEqual(response["status"], "ok")
        self.assertFalse(response["spoken"])
        self.assertEqual(response["heard"], "You remember me?")
        self.assertEqual(len(history["game-npc-42"]), 2)
        self.assertEqual(history["game-npc-42"][1]["role"], "assistant")

    def test_second_turn_reuses_history(self):
        memory = {"game-npc-42": [{"role": "user", "content": "hi"}]}
        def chat(model, name, score, disposition, rows, line, endpoint, encounters=None):
            self.assertEqual(rows[0]["content"], "hi")
            return "Remembered."
        response, updated = handle_request(REQ, memory, model="fake", whisper_model="base",
                                           device="cpu", mic_seconds=1, enable_tts=False,
                                           chat_fn=chat)
        self.assertEqual(response["reply"], "Remembered.")
        self.assertEqual(len(updated["game-npc-42"]), 3)

    def test_voice_mode_invokes_microphone_once(self):
        called = []
        def record(*args):
            called.append(args)
            return "Hey choom"
        result, _ = handle_request({**REQ, "mode": "microphone", "player_line": ""},
                                   {}, model="fake", whisper_model="base", device="cpu",
                                   mic_seconds=4, enable_tts=True, microphone_fn=record,
                                   chat_fn=lambda *args, **kwargs: "Well hello.",
                                   speak_fn=lambda line: True)
        self.assertEqual(len(called), 1)
        self.assertEqual(result["heard"], "Hey choom")
        self.assertTrue(result["spoken"])

    def test_preserves_manual_encounters_for_dialogue(self):
        context = []
        def chat(*args, **kwargs):
            context.extend(kwargs["encounters"])
            return "I remember that."
        response, history = handle_request(
            {**REQ, "encounters": ["helped", "betrayed"]}, {}, model="fake",
            whisper_model="base", device="cpu", mic_seconds=1, enable_tts=False,
            chat_fn=chat,
        )
        self.assertEqual(context, ["helped", "betrayed"])
        self.assertEqual(response["status"], "ok")

    def test_rejects_unknown_encounter(self):
        with self.assertRaises(ValueError):
            validate_request({**REQ, "encounters": ["unknown-action"]})

    def test_local_ollama_http_protocol_mock(self):
        raw = json.dumps({"message": {"content": "I remember the favor."}}).encode("utf-8")
        fake_response = io.BytesIO(raw)
        with mock.patch("bridge_service.urllib.request.urlopen", return_value=fake_response) as urlopen:
            reply = local_chat(
                "fake", "Test NPC", 18, "neutral", [], "Remember me?",
                encounters=["helped"],
            )
            request = urlopen.call_args.args[0]
            body = json.loads(request.data.decode("utf-8"))
        self.assertEqual(reply, "I remember the favor.")
        self.assertIn("helped", body["messages"][0]["content"])
        self.assertEqual(body["messages"][-1]["content"], "Remember me?")
        self.assertEqual(request.full_url, "http://127.0.0.1:11434/api/chat")

    def test_file_worker_roundtrip_with_mock_response(self):
        with tempfile.TemporaryDirectory() as folder:
            p = Path(folder)
            save_json_atomic(p / REQUEST_NAME, REQ)
            reply = {"schema": 1, "id": REQ["id"], "status": "ok", "npc_name": REQ["npc_name"], "reply": "Yes"}
            history = {REQ["npc_key"]: [{"role": "assistant", "content": "Yes"}]}
            with mock.patch("bridge_service.handle_request", return_value=(reply, history)), \
                    mock.patch("bridge_service.time.sleep", side_effect=KeyboardInterrupt):
                serve(p, model="fake", whisper_model="base", device="cpu",
                      mic_seconds=1, enable_tts=False, poll_seconds=0.1)
            self.assertEqual(load_json(p / RESPONSE_NAME)["reply"], "Yes")
            self.assertEqual(load_json(p / HISTORY_NAME)[REQ["npc_key"]][0]["content"], "Yes")

    def test_cli_rejects_microphone_too_long(self):
        with self.assertRaises(SystemExit):
            cli(["--mod-dir", ".", "--mic-seconds", "60"])


if __name__ == "__main__":
    unittest.main()
