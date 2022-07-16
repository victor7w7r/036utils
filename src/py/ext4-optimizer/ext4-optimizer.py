from subprocess import call, PIPE, Popen
from sys import stdout, platform, version_info
from os import system
from time import sleep

import inquirer

from lib.commandverify import commandverify
from lib.cover import cover
from lib.printer import printer
from lib.reader import reader
from lib.utils import utils

LANGUAGE: int = 0

def core() -> None: utils.clear(); language(); cover(); verify(); menu()

def language() -> None:

    global LANGUAGE

    print('Welcome / Bienvenido')

    q = [
        inquirer.List('language',
            message='Please, choose your language / Por favor selecciona tu idioma',
            choices=['English', 'Espanol'])
    ]

    data = inquirer.prompt(q)
    if data['language'] == 'English': LANGUAGE = 1
    else: LANGUAGE = 2

def verify() -> None:

    if version_info < (3, 5):
        utils.clear(); printer("error",8, LANGUAGE); exit(1)
    if platform != "linux":
        utils.clear(); printer("error",0, LANGUAGE); exit(1)
    if not commandverify("e4defrag"):
        utils.clear(); printer("error",2, LANGUAGE); exit(1)
    if not commandverify("fsck.ext4"):
        utils.clear(); printer("error",3, LANGUAGE); exit(1)
    ext4listener(); printer("print",5, LANGUAGE)
    spinner = utils.spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')
    utils.clear()

def ext4listener(menuable: str = "", echoparts: str = "") -> list[str]:

    COUNT: int = 0; EXTCOUNT: int = 0; MOUNTCOUNT: int = 0
    ABSOLUTEPARTS: str = ""; DIRTYDEVS: list = []
    EXTPARTS: list = []; PARTS: list = []
    UMOUNTS: list[str, str] = []

    ROOT: str = Popen(r"""df -h | sed -ne '/\/$/p' | cut -d" " -f1
                        """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').replace("\n", "")
    VERIFY: str = Popen(r"""find /dev/disk/by-id/ | sort -n | sed 's/^\/dev\/disk\/by-id\///'
                        """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').split("\n")

    for DEVICE in VERIFY:
        DIRTYDEVS.append(Popen(f'readlink "/dev/disk/by-id/{DEVICE}"', shell=True, stdout=PIPE)
                        .stdout.read().decode('utf-8').rstrip().split("\n")[0])

    DIRTYDEVS = list(filter(('').__ne__, DIRTYDEVS))

    for DEV in DIRTYDEVS:
        ABSOLUTEPARTS = Popen(f"""
                            echo {DEV} | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'""",
                            shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if ABSOLUTEPARTS != "":
            if ABSOLUTEPARTS != ROOT:
                PARTS.append(Popen(f"echo {DEV} | sed 's/^\.\.\/\.\.\///' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'",
                                    shell=True, stdout=PIPE).stdout.read()
                                    .decode('utf-8').rstrip().split("\n")[0]); COUNT += 1

    for PART in PARTS:
        TYPE: str = Popen(f'''lsblk -f /dev/{PART} | sed -ne '2p' | cut -d " " -f2''',
                    shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if TYPE == "ext4": EXTCOUNT += 1; EXTPARTS.append(PART)

    if (EXTCOUNT == 0):
        utils.clear(); printer("error",6,LANGUAGE)
        if menuable == "menu" : input(reader(4)); return
        else: exit(1)

    for PARTITIONSDEF in EXTPARTS:
        MOUNTED: str = Popen(f"lsblk /dev/{PARTITIONSDEF} | sed -ne '/\//p'",
                            shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if MOUNTED != "": MOUNTCOUNT += 1
        else: UMOUNTS.append(f"/dev/{PARTITIONSDEF}")

    if MOUNTCOUNT == EXTCOUNT :
        utils.clear(); printer("error",7,LANGUAGE)
        if(menuable == "menu"): input(reader(4, LANGUAGE)); return
        else: exit(1)

    if echoparts == "print": return UMOUNTS

def menu() -> None:

    q = [
        inquirer.List('menu',
            message=reader(0, LANGUAGE),
            choices=[reader(1, LANGUAGE), reader(2, LANGUAGE)])
    ]
    answers = inquirer.prompt(q)
    if(answers['menu'] == reader(1, LANGUAGE)):
        utils.clear(); defragmenu()
    else: utils.clear(); exit(0)

def defragmenu() -> None:

    q = [
        inquirer.List('menu',
            message=reader(0, LANGUAGE),
            choices=ext4listener("menu","print"))
    ]
    answers = inquirer.prompt(q)
    utils.clear()
    defragaction(answers['menu'])

def defragaction(part: str) -> None:

    utils.clear()
    if part == "": return

    printer("print",8,LANGUAGE)

    if call("sudo cat < /dev/null", shell=True) == 0:
        if call(f"sudo fsck.ext4 -y -f -v {part}", shell=True) != 8:
            print(" "); printer("print",10,LANGUAGE); input(reader(4, LANGUAGE)); utils.clear()
        else: printer("print",9,LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

        printer("print",11,LANGUAGE)

        if call(f"sudo fsck.ext4 -y -f -v -D {part}", shell=True) != 8:
            print(" "); printer("print",10,LANGUAGE); input(reader(4, LANGUAGE)); utils.clear()
        else: printer("print",9,LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

        system("mkdir /tmp/optimize 2> /dev/null")
        system(f"sudo mount {part} /tmp/optimize")

        printer("print",12,LANGUAGE); system(f"sudo e4defrag -v {part}")
        print(" ")
        system(f"sudo umount {part}"); printer("print",10,LANGUAGE)
        input(reader(4, LANGUAGE)); utils.clear()

        printer("print",13,LANGUAGE)

        if call(f"sudo fsck.ext4 -y -f -v {part}", shell=True) != 8:
            print(" "); printer("print",10,LANGUAGE); input(reader(4, LANGUAGE)); utils.clear(); menu()
        else: printer("print",9,LANGUAGE); input(reader(4, LANGUAGE)); menu(); return
    else: printer("print",9,LANGUAGE); input(reader(4, LANGUAGE)); menu(); return

if __name__ == "__main__": core()
