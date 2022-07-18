from subprocess import PIPE, Popen
from sys import stdout, platform, version_info
from os import system
from re import search
from time import sleep

import inquirer

from lib.utils import clear, spinning, cover, commandverify, usbverify, live_tasker, live_tasker_poweroff
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
        clear(); printer("error", 11, LANGUAGE); exit(1)
    if platform != "linux":
        clear(); printer("error",0, LANGUAGE); exit(1)
    if not commandverify("whiptail"):
        clear(); printer("error",3, LANGUAGE); exit(1)
    if not commandverify("udisksctl"):
        clear(); printer("error",2, LANGUAGE); exit(1)
    SERVICE: str = Popen('systemctl is-active udisks2', shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip('\n')
    if SERVICE == "inactive":
        clear(); printer("error",4, LANGUAGE); exit(1)
    usbverify(); printer("print",5, LANGUAGE)
    spinner = spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')

def menu() -> None:

    q = [inquirer.List('menu',
        message=reader(0, LANGUAGE),
        choices=[
            reader(1, LANGUAGE), reader(2, LANGUAGE),
            reader(3, LANGUAGE), reader(4, LANGUAGE)
        ]
    )]

    answers = inquirer.prompt(q)

    if answers['menu'] == reader(1, LANGUAGE): clear(); usblistener("mount")
    elif answers['menu'] == reader(2, LANGUAGE): clear(); usblistener("unmount")
    elif answers['menu'] == reader(3, LANGUAGE): clear(); usblistener("off")
    elif answers['menu'] == reader(4, LANGUAGE): clear(); exit(0)
    else: clear(); exit(0)

def usblistener(selector: str) -> None:

    clear(); usbverify()
    COUNT: int = 0; PARTS: list = []; BLOCK: list = []
    FLAGS: list = []; MOUNTS: list = []; USB: list = []
    UNMOUNTS: list = []; ARGS: list = []; ARGSPOWEROFF: list = []
    MOUNTCOUNT: int = 0; UNMOUNTCOUNT: int = 0; TYPE: str = ""
    MODEL: str = ""; FLAGSCOUNT: int = 0; DIRTYDEVS: list = []

    USB = Popen(r"""find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\/dev\/disk\/by-id\///'
                    """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip().split('\n')
    for DEVICE in USB:
        DIRTYDEVS.append(Popen(f'readlink "/dev/disk/by-id/{DEVICE}"', shell=True,
                            stdout=PIPE).stdout.read().decode('utf-8').rstrip().split("\n")[0])

    DIRTYDEVS = list(filter(('').__ne__, DIRTYDEVS))
    for DEV in DIRTYDEVS:
        ABSOLUTEPARTS = Popen(f"""
                            echo {DEV} | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'""",
                            shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()

        if ABSOLUTEPARTS != "":
            PARTS.append(Popen(f"""
                                echo {DEV} | sed 's/^\.\.\/\.\.\///' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'""",
                                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip().split("\n")[0])
            COUNT += 1
        else:
            BLOCK.append(Popen(f"echo {DEV} | sed 's/^\.\.\/\.\.\///'", shell=True, stdout=PIPE).stdout.read()
                            .decode('utf-8').rstrip().split("\n")[0])
            FLAGS.append(COUNT)

    for PARTITIONS in PARTS:
        MOUNTED: str = Popen(f"lsblk /dev/{PARTITIONS} | sed -ne '/\//p'", shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if MOUNTED != "": UNMOUNTCOUNT += 1; MOUNTS.append(PARTITIONS)
        else: MOUNTCOUNT += 1; UNMOUNTS.append(PARTITIONS)

    if selector == "mount":
        if UNMOUNTCOUNT == COUNT: printer("error",7); input(reader(5)); menu(); return
        COUNT=0
        for PART in UNMOUNTS:
            DEVICE: str = f"/dev/{PART}"
            TYPE: str = Popen(r'''
                lsblk -f /dev/'''+PART+''' | sed -ne '2p' | cut -d " " -f2''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            try: TEMP = FLAGS[FLAGSCOUNT]
            except IndexError: pass
            if COUNT == TEMP :
                try: BLOCKSTAT = BLOCK[FLAGSCOUNT]
                except IndexError: pass
                FLAGSCOUNT += 1
            MODEL: str = Popen(f'''
                cat /sys/class/block/{BLOCKSTAT}/device/model''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGS.append([DEVICE, MODEL + " " + TYPE]); COUNT+=1

        q = [inquirer.List('menu',
            message=reader(6, LANGUAGE),
            choices=ARGS
        )]

        answers = inquirer.prompt(q)
        clear(); mountaction(answers['menu'])

    elif selector == "unmount":
        if MOUNTCOUNT == COUNT: printer("error",10); input(reader(5)); menu(); return
        COUNT=0
        for PART in MOUNTS:
            DEVICE: str = "/dev/"+PART
            TYPE: str = Popen(r'''
                lsblk -f /dev/'''+PART+''' | sed -ne '2p' | cut -d " " -f2''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            try: TEMP = FLAGS[FLAGSCOUNT]
            except IndexError: pass
            if COUNT == TEMP:
                try: BLOCKSTAT = BLOCK[FLAGSCOUNT]
                except IndexError: pass
                FLAGSCOUNT += 1
            MODEL: str = Popen(f'''
                cat /sys/class/block/{BLOCKSTAT}/device/model''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGS.append([DEVICE, MODEL + " " + TYPE]); COUNT +=1

        q = [inquirer.List('menu',
            message=reader(9, LANGUAGE),
            choices=ARGS
        )]

        answers = inquirer.prompt(q)
        clear(); unmountaction(answers['menu'])

    elif(selector == "off"):
        COUNT=0
        for PART in BLOCK:
            DEVICE: str = "/dev/"+PART
            BLOCKSTAT = BLOCK[COUNT]
            MODEL: str = Popen(f'''
                cat /sys/class/block/{BLOCKSTAT}/device/model''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGSPOWEROFF.append([DEVICE, MODEL]); COUNT += 1
        q = [inquirer.List('menu',
            message=reader(11, LANGUAGE),
            choices=ARGS
        )]

        answers = inquirer.prompt(q)
        clear(); poweroffaction(answers['menu'])

def mountaction(part: str) -> None:

    clear()
    if part == "": return

    capture = live_tasker(f"udisksctl mount -b {part}")

    if capture[0] == 0:
        system(f"whiptail --title '{reader(8)}' --msgbox '{reader(8)+capture[1]}' 7 35")
        menu()
    else:
        if search("NotAuthorized*",capture[1]):
            clear(); printer("error",8); input(reader(5)); menu()
        elif search("NotAuthorizedDismissed*",capture[1]):
            clear(); printer("error",8); input(reader(5)); menu()
        elif search("AlreadyMounted*",capture[1]):
            clear(); printer("error",9); input(reader(5)); menu()

def unmountaction(part: str) -> None:

    clear()
    if part == "": return

    capture = live_tasker(f"udisksctl unmount -b {part}")

    if capture[0] == 0:
        system(f"whiptail --title '{reader(8)}' --msgbox '{reader(8)+capture[1]}' 7 35")
        menu()
    else:
        if search("NotAuthorized*",capture[1]):
            clear(); printer("error",8); input(reader(5)); menu()
        elif search("NotAuthorizedDismissed*",capture[1]):
            clear(); printer("error",8); input(reader(5)); menu()
        elif search("AlreadyMounted*",capture[1]):
            clear(); printer("error",9); input(reader(5)); menu()

def poweroffaction(part: str) -> None:

    clear()
    if part == "": return

    BLOCKTEMP: str = Popen(f'echo {part} | cut -d "/" -f3',
                            shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()

    PARTITIONSQUERY: list = Popen("""find /dev -name \"""" +BLOCKTEMP+
                                    """[[:digit:]]\" | sort -n | sed 's/^\/dev\///'""", shell=True,
                                stdout=PIPE).stdout.read().decode('utf-8').rstrip().split("\n")

    for PARTITION in PARTITIONSQUERY:
        capture: list = live_tasker(f"udisksctl unmount -b {PARTITION} &> /dev/null")
        if capture[0] == 0:
            spinner = spinning()
            for _ in range(10):
                stdout.write(next(spinner))
                stdout.flush(); sleep(0.1)
                stdout.write('\b')
        else:
            if LANGUAGE == 1:
                system(f"whiptail --title 'ERROR' --msgbox 'FAIL: Error unmounting /dev/{PARTITION} please check or check if you have the right permissions' 7 35")
                menu(); return
            else:
                system(f"whiptail --title 'ERROR' --msgbox 'ERROR: Hubo un error desmontando /dev/{PARTITION} por favor revisar o mira si tienes permisos' 7 35")
                menu(); return

    MODEL: str = Popen(f'cat /sys/class/block/{BLOCKTEMP}/device/model',
                        shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()

    capture: int = live_tasker_poweroff(f"udisksctl power-off -b {part}")

    if capture == 0:
        if LANGUAGE == 1:
            system(f"whiptail --title 'SUCCESS' --msgbox 'SUCCESS: Your device {MODEL} was succesfully power-off' 7 35")
            menu()
        else:
            system(f"whiptail --title 'LISTO' --msgbox 'LISTO: Tu dispositivo {MODEL} se ha apagado exitosamente' 7 35")
            menu()
    else:
        if LANGUAGE == 1:
            system(f"whiptail --title 'FAIL' --msgbox 'FAIL: Power-off is not available on this device, please check or check if you have permissions' 7 35")
            menu(); return
        else:
            system(f"whiptail --title 'ERROR' --msgbox 'ERROR: no está disponible el apagar este dispositivo, por favor revisar o mira si tienes permisos' 7 35")
            menu(); return

if __name__ == "__main__": core()
