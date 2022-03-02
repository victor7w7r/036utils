from subprocess import call, PIPE, Popen
from sys import stdin, stdout, platform, version_info
from os import system
from termios import tcgetattr, tcsetattr, TCSADRAIN
from time import sleep
from tty import setcbreak
from dialog import Dialog

d = Dialog(dialog="dialog")
d.set_background_title("036 Creative Studios")

LANGUAGE: int = 0

def main() -> None: utils.clear(); language(); cover(); verify(); menu()

def printer(type: str, position: int) -> None:
    
    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m'

    DICTIONARY_ENG=(
	"Your Operating System is not GNU/Linux, exiting",
	"In this system the binary sudo doesn't exist.",
	"e4defrag binary is not present in this system, please install",
	"fsck.ext4 is not present in this system, please install",
	"The dialog binary is not available in this system, please install",
	"All dependencies is ok!",
	"There's not ext4 partitions available, only works with USB devices",
	"All the ext4 partitions are mounted in your system, please unmount the desired partition to optimize",
	"=============== VERIFY FILESYSTEM ERRORS =============== \n",
	"=============== FAILURE =============== \n",
	"=============== OK =============== \n",
	"=============== OPTIMIZE FILESYSTEM =============== \n",
	"=============== DEFRAG FILESYSTEM, PLEASE WAIT =============== \n",
	"=============== LAST VERIFY FILESYSTEM =============== \n",
    "Your Python versión is less than 3.5, exiting",
    "You need to be root, execute with sudo"
    )
    
    DICTIONARY_ESP=(
        "Este sistema no es GNU/Linux, saliendo",
	"En este sistema no existe el binario de superusuario.",
	"El ejecutable e4defrag no está presente en tu sistema, por favor instalalo",
	"fsck.ext4 no está presente en tu sistema, por favor instalalo",
	"dialog no está presente en tu sistema, por favor instalalo",
	"Todo ok!",
	"No hay particiones ext4 disponibles en el sistema, solofunciona con dispositivos USB",
	"Todas las particiones ext4 estan montadas en el sistema, por favor desmontar la particion deseada para optimizar",
	"=============== VERIFICAR ERRORES EN EL SISTEMA DE ARCHIVOS =============== \n",
	"=============== FALLA =============== \n",
	"=============== LISTO =============== \n",
	"=============== OPTIMIZAR EL SISTEMA DE ARCHIVOS =============== \n",
	"=============== DESFRAGMENTAR EL SISTEMA DE ARCHIVOS, ESPERE POR FAVOR =============== \n",
	"=============== VERIFICAR POR ULTIMA VEZ EL SISTEMA DE ARCHIVOS =============== \n",
    "Tu versión de Python es menor que 3.5, saliendo",
    "Necesitas ser superusuario, ejecuta con sudo"
    )
    
    if LANGUAGE == 1:
        if type == "print": print(f"{DICTIONARY_ENG[position]}")
        elif type == "info": print(f"[{GREEN}+{ENDC}] INFO: {DICTIONARY_ENG[position]}")
        elif type == "warn": print(f"[{WARNING}*{ENDC}] WARNING: {DICTIONARY_ENG[position]}")
        elif type == "error": print(f"[{FAIL}!{ENDC}] ERROR: {DICTIONARY_ENG[position]}")
        else: print(f"[?] UNKNOWN: {DICTIONARY_ENG[position]}")
    else:
        if type == "print": print(f"{DICTIONARY_ESP[position]}")
        elif type == "info": print(f"[{GREEN}+{ENDC}] INFO: {DICTIONARY_ESP[position]}")
        elif type == "warn": print(f"[{WARNING}*{ENDC}] WARNING: {DICTIONARY_ESP[position]}")
        elif type == "error": print(f"[{FAIL}!{ENDC}] ERROR: {DICTIONARY_ESP[position]}")
        else: print(f"[?] UNKNOWN: {DICTIONARY_ESP[position]}")

def reader(position: int) -> str:
    
    DICTIONARY_ENG=(
		"Choose a Option\n", 
		"Optimize a ext4 partition",
		"Exit to the shell",
		"Please select a partition" ,
		"Press Enter to continue...",
		"Optimize",
		"Exit"
	)

    DICTIONARY_ESP=(
		"Seleccione una opcion\n",
		"Optimizar una particion de tipo ext4",
		"Salir al shell",
		"Por favor selecciona una partition",
		"Presione Enter para continuar...",
		"Optimizar",
		"Salir"
	)
 
    if LANGUAGE == 1: return DICTIONARY_ENG[position]
    else: return DICTIONARY_ESP[position]

def commandverify(cmd: str) -> bool:
    return call("type " + cmd, shell=True, stdout=PIPE, stderr=PIPE) == 0

def language() -> None:
    
    global LANGUAGE
    
    print("Bienvenido /  Welcome")
    print("Please, choose your language / Por favor selecciona tu idioma")
    print("1) English"); print("2) Espanol")
    option: str = utils.char()
    if option == "1": LANGUAGE=1
    elif option == "2": LANGUAGE=2
    else: exit(1)

def cover() -> None:
    utils.clear()
    print(r'''                                     `"~>v??*^;rikD&MNBQku*;`                                           ''')
    print(r'''                                `!{wQNWWWWWWWWWWWWWWWNWWWWWWNdi^`                                       ''')
    print(r'''                              .v9NWWWWNRFmWWWWWWWWWWWWga?vs0pNWWWMw!                                    ''')
    print(r'''                            !9WWWWWWU>`>&WWWWWWUH!_JNWWWWWQz  ^EWWWWg|                                  ''')
    print(r'''                           _SWWWWWNe: /RWWWWWWNNHBRuyix&WWWWWg2?-"VNWWW6_                               ''')
    print(r'''                         "kWWWWWNz. .zNWWWWWWw=, ^NsLQNW**MWWWW&WQJuNWWWNr.                             ''')
    print(r'''                       .FNWWWWNu. rL&WWWWWWg!!*;^Jo!*BN0aFx)>|!;;;;;!~\r)xFwaao?|,                      ''')
    print(r'''                     .sNWWWWMi` -,#WWWWWWNi"` Siwu UWv  .;^|^;`               .!*lUSF*;                 ''')
    print(r'''                    )BWWWWWo.   9NWWWWWW0; ;PvLc*aU&^ |L=-``.;>*=                   ;)wmkL_             ''')
    print(r'''                  _QWWWWWq"   .aWWWWWWWs`  rF<>\^gQ, /i   ,;;.  !2                      ,*k0F\`         ''')
    print(r'''                 *NWWWWNv   ,/&WWWWWWNr "!SL92l)BU.  ^x   x. L,  I_                        `>P&F;       ''')
    print(r'''               `2WWWWWg;    !BWWWWWWD"   .s;!\xNa     /L,   !L`  P,                           .?&gr     ''')
    print(r'''              ,QWWWWWS`  >;LWWWWWWWk`_;!\u|  ^Ml        ;~!^,  `iv                              `?Ng^   ''')
    print(r'''             ^BWWWWWi   *i7NWWWWWWc "a;;?ii"~NV             `;?},                                 ,9WF  ''')
    print(r'''            >WWWWWB!  ` ;8WWWWWWM=  r>`;F/2wNc          .;||!,                                      oW#.''')
    print(r'''           ?WWWWW#"  `2;7NWWWWW&_ =_=u%ir`>Wi                                                        PW6''')
    print(r'''          rWWWWWc   `||>WWWWWWU.  r^?7;!v*W)                                                         ,WW|''')
    print(r'''         ^NWWWB!  ! \jrmWWWWWw  `vL.k*\vkW$>rr*r;`        ;rL{7)>!`                                   mWF''')
    print(r'''        .BWWW$,   ,u. PWWWWW) ,r`)|)!__LWv     `;L"     |s>:```._|JuL                                 qWE''')
    print(r'''        uWWWH` .vi"Fo*WWWWN>   ^v  r*`>W}                                                             &Ws ''')
    print(r'''       ;WWWP`  `=*ox_pWWWB; ^)i`9xr,#7W*            .     ,\*`                                       |WW! ''')
    print(r'''       SWWD` >LLr^_y*NWWQ"  ,<?P~|iF0W}            ~;   v_ `o;                                      .0WU''')
    print(r'''      ^WW0,.!F2xULFi5WW0` >7vr!!z_`*Wv             `|;;^!,~!`                                      .8W8.''')
    print(r'''      dWN;`>JyrkIr`!NWN! ,uFia!9?*2WI                                                             ;QWD.''')
    print(r'''     =WW7`_S)~Fxv| xWWi ;}drqa=;=uWRNmL,                                                         rWWt`  ''')
    print(r'''     DWP`;LiL;}c*rsWW&`,Po_e7L/ =Nc `>oD$aaw%ouic7)*r>=|^^~!;;;;;;;;;;;;;~^\>rvL{JctxiiiiuusoF2kgBS/  ''')
    print(r'''    ;WN\\Uy>*rF.,pWWWr-;?J"vov^^Nu         `.,"_;!~^\=>r*v?LL{}Jjjjjjj}}7?vr>\^!;____-""",,,..``    ''')
    print(r'''    iW?_**>^;>"~&EeWg=|liv*s!~?NL''')
    print(r'''    wWc*$>*~~L6Ni QW! \Uursx >WJ''')
    print(r'''    2M)o*_F "R0; .Wd~U7,``;*iN>''')
    print(r'''    xWe?vI7cMu`  ,W&>xssr~=PB|''')
    print(r'''    "W% ,cBZ_    `M2l\/i,,QQ,''')
    print(r'''     |U$di_       UBu>i)yBy`''')
    print(r'''                  ^Wx,rDR!''')
    print(r'''                   \ZUl^''')
    print(r'''.oPYo. .oPYo. .pPYo.   .oPYo.                       o   o                 .oPYo.   o              8  o                ''')
    print(r'''8  .o8     `8 8        8    8                       8                     8        8              8                   ''')
    print(r'''8 .P`8   .oP` 8oPYo.   8      oPYo. .oPYo. .oPYo.  o8P o8 o    o .oPYo.   `Yooo.  o8P o    o .oPYo8 o8 .oPYo. .oPYo.  ''')
    print(r'''8.d` 8    `b. 8`  `8   8      8  `` 8oooo8 .oooo8   8   8 Y.  .P 8oooo8       `8   8  8    8 8    8  8 8    8 Yb..   ''')
    print(r'''8o`  8     :8 8.  .P   8    8 8     8.     8    8   8   8 `b..d` 8.            8   8  8    8 8    8  8 8    8   `Yb. ''')
    print(r'''`YooP` `YooP` `YooP`   `YooP` 8     `Yooo` `YooP8   8   8  `YP`  `Yooo`   `YooP`   8  `YooP` `YooP`  8 `YooP` `YooP. ''')
    print(r''':.....::.....::.....::::.....:..:::::.....::.....:::..::..::...:::.....::::.....:::..::.....::.....::..:.....::.....:''')
    print(r''':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::''')
    print(r''':::::::::::::::::::   ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::''')

def verify() -> None:

    if version_info < (3, 5):
        utils.clear(); printer("error",8); exit(1)
    if platform != "linux":
        utils.clear(); printer("error",0); exit(1)
    if not commandverify("e4defrag"):
        utils.clear(); printer("error",2); exit(1)
    if not commandverify("fsck.ext4"):
        utils.clear(); printer("error",3); exit(1)
    if not commandverify("dialog"):
        utils.clear(); printer("error",4); exit(1)
    ext4listener(); printer("print",5)    
    spinner = utils.spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)  
        stdout.write('\b')
    utils.clear()
    
def ext4listener(menuable: str = "", echoparts: str = "") -> list[str, str]:
    
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
        if(TYPE == "ext4"): EXTCOUNT += 1; EXTPARTS.append(PART)     
    
    if (EXTCOUNT == 0):
        utils.clear(); printer("error",6)
        if(menuable == "menu"): input(reader(4)); return
        else: exit(1)
        
    for PARTITIONSDEF in EXTPARTS:
        MOUNTED: str = Popen(f"lsblk /dev/{PARTITIONSDEF} | sed -ne '/\//p'", shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if(MOUNTED != ""): MOUNTCOUNT += 1
        else: 
            UMOUNTS.append([f"/dev/{PARTITIONSDEF}","ext4"])
        
    if(MOUNTCOUNT == EXTCOUNT):
        utils.clear(); printer("error",7)
        if(menuable == "menu"): input(reader(4)); return
        else: exit(1)
        
    if(echoparts == "print" ): return UMOUNTS;
        
def menu() -> None:
    choices = [(reader(5),reader(1)),(reader(6),reader(2))]
    response = d.menu(reader(0), 15, 60, 4, choices)
    if(response[0] == "ok" and response[1] == reader(5)):
        defragmenu()
    else: exit(0)

def defragmenu() -> None:
    utils.clear()
    choices = ext4listener("menu","print")
    response = d.menu(reader(0), 15, 50, 4, choices)
    if(response[0] == "ok"):
        defragaction(response[1])
    else: exit(0)

def defragaction(part: str) -> None:
    utils.clear()
    if(part == ""): return
    
    printer("print",8)
    
    if utils.live_tasker("sudo cat < /dev/null") == 0:
        if utils.live_tasker(f"sudo fsck.ext4 -y -f -v {part}") != 8:
            print(" "); printer("print",10); input(reader(4)); utils.clear()
        else:
            printer("print",9); input(reader(4)); menu(); return
            
        printer("print",11)
        
        if utils.live_tasker(f"sudo fsck.ext4 -y -f -v -D {part}") != 8:
            print(" "); printer("print",10); input(reader(4)); utils.clear()
        else:
            printer("print",9); input(reader(4)); menu(); return
            
        call("mkdir /tmp/optimize 2> /dev/null", shell=True) 
        call(f"sudo mount {part} /tmp/optimize", shell=True) 
        
        printer("print",12); utils.live_tasker(f"e4defrag -v {part}")
        print(" ")
        call(f"sudo umount {part}", shell=True); printer("print",10); input(reader(4)); utils.clear()
        
        printer("print",13)
        
        if utils.live_tasker(f"sudo fsck.ext4 -y -f -v {part}") != 8:
            print(" "); printer("print",10); input(reader(4)); utils.clear(); menu()
        else:
            printer("print",9); input(reader(4)); menu(); return
    else:
        printer("print",9); input(reader(4)); menu(); return
    
class utils:
    
    def clear() -> None: system('clear')
    
    def char() -> str:
        fd = stdin.fileno()
        oldSettings = tcgetattr(fd)
        try:
            setcbreak(fd)
            answer = stdin.read(1)
        finally:
            tcsetattr(fd, TCSADRAIN, oldSettings)
        return answer
    
    def live_tasker(cmd: str) -> int:
        task = Popen(cmd, stdout=PIPE, stderr=PIPE, encoding='utf8', shell=True)
        try:  
            while task.poll() is None:
                for line in task.stdout:
                    task.stdout.flush()
                    print(line.replace("\n", ""))
            return task.poll()
        except: return 1
    
    def spinning():
        while True:
            for cursor in '|/-\\':
                yield cursor

if __name__ == "__main__":
    main()
