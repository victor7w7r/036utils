from subprocess import PIPE, Popen

from lib.utils import clear
from lib.printer import printer
from lib.reader import reader

def ext4listener(language: int, menuable: str = "", echoparts: str = "") -> list[str]:

    COUNT: int = 0; EXTCOUNT: int = 0; MOUNTCOUNT: int = 0
    ABSOLUTEPARTS: str = ""; DIRTYDEVS: list = []
    EXTPARTS: list = []; PARTS: list = []
    UMOUNTS: list[str, str] = []

    ROOT: str = Popen(r"""df -h | sed -ne '/\/$/p' | cut -d " " -f1
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
        clear(); printer("error", 5, language)
        if menuable == "menu" : input(reader(4)); return
        else: exit(1)

    for PARTITIONSDEF in EXTPARTS:
        MOUNTED: str = Popen(f"lsblk /dev/{PARTITIONSDEF} | sed -ne '/\//p'",
            shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if MOUNTED != "": MOUNTCOUNT += 1
        else: UMOUNTS.append(f"/dev/{PARTITIONSDEF}")

    if MOUNTCOUNT == EXTCOUNT :
        clear(); printer("error", 6, language)
        if(menuable == "menu"): input(reader(4, language)); return
        else: exit(1)

    if echoparts == "print": return UMOUNTS