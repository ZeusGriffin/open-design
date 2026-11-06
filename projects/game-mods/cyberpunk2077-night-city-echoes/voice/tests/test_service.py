"""Offline bridge tests. No microphone, Ollama, Windows or game required."""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from bridge_service import (load_json, save_json_atomic, validate_request,
                            handle_request, cli)

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

    def test_cli_rejects_microphone_too_long(self):
        with self.assertRaises(SystemExit):
            cli(["--mod-dir", ".", "--mic-seconds", "60"])


if __name__ == "__main__":
    unittest.main()
