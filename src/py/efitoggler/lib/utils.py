from os import system

class utils:
    def clear() -> None: system('clear')

    def spinning():
        while True:
            for cursor in '|/-\\':
                yield cursor