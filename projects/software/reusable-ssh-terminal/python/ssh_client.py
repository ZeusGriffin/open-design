"""Reusable SSH command client. Not an interactive PTY terminal.
Install: python -m pip install paramiko
Prerequisite: host public key already trusted in ~/.ssh/known_hosts.
"""
import os
import paramiko

class SSHClient:
    def __init__(self, host, username, port=22, key_file=None):
        self.host, self.username, self.port = host, username, port
        self.key_file = key_file
        self.client = None

    def connect(self):
        client = paramiko.SSHClient()
        client.load_system_host_keys()
        client.set_missing_host_key_policy(paramiko.RejectPolicy())
        try:
            client.connect(hostname=self.host, port=self.port,
                           username=self.username, key_filename=self.key_file,
                           look_for_keys=True, allow_agent=True, timeout=10)
        except Exception:
            client.close()
            raise
        self.client = client

    def execute(self, command):
        if self.client is None:
            raise RuntimeError("Not connected")
        _stdin, stdout, stderr = self.client.exec_command(command)
        out = stdout.read().decode(errors="replace")
        err = stderr.read().decode(errors="replace")
        code = stdout.channel.recv_exit_status()
        return {"stdout": out, "stderr": err, "exit_code": code}

    def close(self):
        if self.client is not None:
            self.client.close()
            self.client = None

if __name__ == "__main__":
    client = SSHClient(os.environ["SSH_HOST"], os.environ["SSH_USER"])
    try:
        client.connect()
        print(client.execute("whoami"))
    finally:
        client.close()
