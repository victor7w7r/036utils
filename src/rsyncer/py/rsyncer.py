from subprocess import call
from sys import stdout, platform, version_info
from os import path
from re import search
from time import sleep

import inquirer

from lib.utils import clear, spinning, cover, commandverify
from lib.printer import printer
from lib.reader import reader

SOURCE: str = ""; DEST: str = ""; LANGUAGE: int = 0

def core() -> None: clear(); language(); cover(); verify()

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
        clear(); printer("error", 7, LANGUAGE); exit(1)
    if platform != "linux":
        clear(); printer("error", 0, LANGUAGE); exit(1)
    if not commandverify("rsync"):
        clear(); printer("error", 2, LANGUAGE); exit(1)
    printer("print",3,LANGUAGE)
    spinner = spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')

    clear(); sourceaction()

def validator(type: str, data: str) -> None:

    global SOURCE; global DEST

    if type == "source":
        if data != "":
            if path.exists(data):
                SOURCE=data; clear(); destiaction(); return
            else:
                clear(); printer("error", 4, LANGUAGE, data)
                input(reader(2, LANGUAGE)); clear(); sourceaction()
        else: exit(0)
    elif type == "dest":
        if data != "":
            if path.exists(data):
                DEST=data; clear(); syncer(); return
            else:
                clear(); printer("error", 4, LANGUAGE, data)
                input(reader(2, LANGUAGE)); clear(); destiaction()
                return
        else: sourceaction()
    else: exit(0)

def sourceaction() -> None:

    q = [inquirer.Text('source', message=reader(0, LANGUAGE))]
    data = inquirer.prompt(q)
    validator("source", data['source'])

def destiaction() -> None:

    q = [inquirer.Text('dest', message=reader(1, LANGUAGE))]
    data = inquirer.prompt(q)
    validator("dest", data['dest'])

def syncer() -> None:

    SOURCEREADY: str=""; DESTREADY: str = ""
    if search(".*\/$", SOURCE): SOURCEREADY = SOURCE
    else: SOURCEREADY = SOURCE + '/'
    if search(".*\/$", DEST): DESTREADY = DEST
    else: DESTREADY = DEST + '/'

    clear(); printer("print", 5, LANGUAGE)
    print(f"SOURCE:{SOURCEREADY}"); print(f"DESTINATION:{DESTREADY}")

    if call(f"rsync -axHAWXS --numeric-ids --info=progress2 {SOURCEREADY} {DESTREADY}", shell=True) == 0:
        print("\n =============== OK =============== \n" )
        printer("print", 6, LANGUAGE); exit(0)
    else:
        clear(); printer("print", 8, LANGUAGE)
        print(f"SOURCE:{SOURCEREADY}"); print(f"DESTINATION:{DESTREADY}")
        if call(f"sudo rsync -axHAWXS --numeric-ids --info=progress2 {SOURCEREADY} {DESTREADY}", shell=True) == 0:
            print("\n =============== OK =============== \n" )
            printer("print", 6, LANGUAGE); exit(0)
        else: printer("print", 9, LANGUAGE); exit(1)

if __name__ == "__main__": core()