from subprocess import call, PIPE
from os import system

class utils:
    def clear() -> None: system('clear')

    def spinning():
        while True:
            for cursor in '|/-\\':
                yield cursor

    def commandverify(cmd: str) -> bool:
        return call("type " + cmd, shell=True, stdout=PIPE, stderr=PIPE) == 0