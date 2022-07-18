from subprocess import call
from sys import stdout, platform, version_info
from os import system
from time import sleep

import inquirer

from lib.utils import clear, spinning, cover, commandverify
from lib.ext4listener import ext4listener
from lib.printer import printer
from lib.reader import reader

LANGUAGE: int = 0

def core() -> None: clear(); language(); cover(); verify(); menu()

def language() -> None:

    global LANGUAGE

    print('Welcome / Bienvenido')

    q = [inquirer.List('language',
        message='Please, choose your language / Por favor selecciona tu idioma',
        choices=['English', 'Espanol']
    )]

    data = inquirer.prompt(q)
    if data['language'] == 'English': LANGUAGE = 1
    else: LANGUAGE = 2

def verify() -> None:

    if version_info < (3, 5):
        clear(); printer("error", 13, LANGUAGE); exit(1)
    if platform != "linux":
        clear(); printer("error", 0, LANGUAGE); exit(1)
    if not commandverify("e4defrag"):
        clear(); printer("error", 2, LANGUAGE); exit(1)
    if not commandverify("fsck.ext4"):
        clear(); printer("error", 3, LANGUAGE); exit(1)
    ext4listener(LANGUAGE); printer("print", 4, LANGUAGE)
    spinner = spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')
    clear()

def menu() -> None:

    q = [inquirer.List('menu',
        message=reader(0, LANGUAGE),
        choices=[reader(1, LANGUAGE), reader(2, LANGUAGE)]
    )]
    answers = inquirer.prompt(q)
    if(answers['menu'] == reader(1, LANGUAGE)):
        clear(); defragmenu()
    else: clear(); exit(0)

def defragmenu() -> None:

    CHOICES = ext4listener(LANGUAGE, "menu", "print")
    CHOICES.append(reader(6, LANGUAGE))

    q = [inquirer.List('menu',
        message=reader(0, LANGUAGE),
        choices=CHOICES
    )]

    answers = inquirer.prompt(q)
    if answers['menu'] == reader(6, LANGUAGE): clear(); menu()
    else: clear(); defragaction(answers['menu'])

def defragaction(part: str) -> None:

    clear()
    if part == "": return

    printer("print", 7, LANGUAGE)

    if call("sudo cat < /dev/null", shell=True) == 0:
        if call(f"sudo fsck.ext4 -y -f -v {part}", shell=True) != 8:
            print(" "); printer("print", 9, LANGUAGE); input(reader(4, LANGUAGE)); clear()
        else: printer("print", 8, LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

        printer("print", 10, LANGUAGE)

        if call(f"sudo fsck.ext4 -y -f -v -D {part}", shell=True) != 8:
            print(" "); printer("print", 9, LANGUAGE); input(reader(4, LANGUAGE)); clear()
        else: printer("print", 8,LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

        system("mkdir /tmp/optimize 2> /dev/null")
        system(f"sudo mount {part} /tmp/optimize")

        printer("print", 11, LANGUAGE); system(f"sudo e4defrag -v {part}")
        print(" ")
        system(f"sudo umount {part}"); printer("print", 9, LANGUAGE)
        input(reader(4, LANGUAGE)); clear()

        printer("print", 12, LANGUAGE)

        if call(f"sudo fsck.ext4 -y -f -v {part}", shell=True) != 8:
            print(" "); printer("print", 9, LANGUAGE); input(reader(4, LANGUAGE)); clear(); menu()
        else: printer("print", 8, LANGUAGE); input(reader(4, LANGUAGE)); menu(); return
    else: printer("print", 8, LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

if __name__ == "__main__": core()
