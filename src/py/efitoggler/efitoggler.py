from subprocess import Popen, call, PIPE
from sys import stdout, platform, version_info
from time import sleep
from os import system

import inquirer

from lib.utils import clear, spinning, cover
from lib.printer import printer

LANGUAGE: int = 0

def core() -> None: clear(); language(); cover(); verify(); toggle()

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

    if platform != "darwin":
        clear(); printer("error", 0, LANGUAGE); exit(1)
    if version_info < (3, 5):
        clear(); printer("error", 5, LANGUAGE); exit(1)
    printer("print", 1, LANGUAGE)
    spinner = spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')

def toggle() -> None:

    EFIPART: str = Popen(r"""diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\(d.*\).*/\1/p'
        """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip("\n")

    EFI: str = Popen(r"""EFIPART=$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\(d.*\).*/\1/p')
            MOUNTROOT=$(df -h | sed -ne "/$EFIPART/p"); echo $MOUNTROOT
        """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip("\n")

    if EFI != "":
        printer("print", 2, LANGUAGE)
        if call("sudo cat < /dev/null", shell=True) == 0:
            system(f"sudo diskutil unmount {EFIPART}")
            system("sudo rm -rf /Volumes/EFI")
            clear(); printer("print", 4, LANGUAGE)
        else: clear(); printer("error", 6, LANGUAGE); exit(1)

    else:
        printer("print", 3, LANGUAGE)
        if call("sudo cat < /dev/null", shell=True) == 0:
            system("sudo mkdir /Volumes/EFI")
            system(f"sudo mount -t msdos /dev/{EFIPART} /Volumes/EFI")
            system("open /Volumes/EFI")
            clear(); printer("print", 4, LANGUAGE)
        else: clear(); printer("error", 6, LANGUAGE); exit(1)

if __name__ == "__main__": core()