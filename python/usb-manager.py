from subprocess import call, PIPE, Popen, check_output, CalledProcessError
from sys import stdin, stdout, platform, version_info
from os import system
from re import search
from termios import tcgetattr, tcsetattr, TCSADRAIN
from time import sleep
from tty import setcbreak
from dialog import Dialog

d = Dialog(dialog="dialog")
d.set_background_title("036 Creative Studios")

LANGUAGE: int = 0

def main() -> None: utils.clear(); language(); cover(); verify(); menu()

def printer(type: str, position: int, additional: str = "") -> None:
    
    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m';
  
    DICTIONARY_ENG=(
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The udisks command line tool (udisksctl) doesn't exist, please install udisks2",
		"The dialog binary is not available in this system, please install",
		"The udisks2 service is not running, please enable the service",
		"All dependencies is ok!",
		"There's no USB drives connected in this PC, or the devices are shutdown",
		"All the partitions are mounted in your system",
		"Your attempt to get authorization is not valid (Invalid Password)",
		"This partition is already mounted",
	 	"There's not partitions mounted in your system",
		"Your partition is unmounted",
        "Your Python versión is less than 3.5, exiting",
        "You need to be root, execute with sudo"
	)

    DICTIONARY_ESP=(
	    "Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El \"udisks command line tool (udisksctl)\" no existe, por favor instale udisks2",
		"El ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
		"El servicio udisks2 no esta ejecutandose, por favor ejecutalo",
		"Todo ok!",
		"No hay dispositivos USB conectados en esta PC, o los mismos estan apagados",
		"Todas las particiones estan montadas en el sistema",
		"Tu intento de autorizacion como superusuario no fue exitoso (Contrasena Incorrecta)",
		"Esta particion esta montada actualmente",
		"No hay particiones montadas en el sistema",
		"Esta particion no esta montada",
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
		"Mount a partition of a device",
		"Unmount a partition of a device",
		"Unmount and secure turn-off a USB",
		"Exit to the shell",
		"Press Enter to continue...",
		"Mount a Partition",
		"Please Mount a partition \n",
		"SUCCESS: ",
		"Umount a Partition",
		"Please umount a partition \n",
		"Poweroff a Device",
		"Choose for poweroff a device \nCAUTION: All the partitions will be force unmounted",
		"Mount",
		"Unmount",
		"Power-off",
		"Exit"
	)

    DICTIONARY_ESP=(
		"Elija una opcion\n",
		"Montar una particion de un dispositivo",
		"Desmontar una particion de un dispositivo",
		"Desmontar todo y expulsar de manera segura un dispositivo",
		"Salir al shell",
		"Presione Enter para continuar...",
		"Montar una particion",
		"Por favor, monta una particion \n",
		"LISTO: ",
		"Desmontar una particion",
		"Por favor, desmonta una particion \n",
		"Apagar un dispositivo",
		"Elija uno para apagar \nCUIDADO: Todas las particiones del dispositivo se desmontaran",
		"Montar",
		"Desmontar",
		"Apagar",
		"Salir"
	)
   
    if LANGUAGE == 1: return DICTIONARY_ENG[position]
    else: return DICTIONARY_ESP[position]

def commandverify(cmd: str) -> bool:
    return call("type " + cmd, shell=True, 
        stdout=PIPE, stderr=PIPE) == 0

def language() -> None:
    
    global LANGUAGE
    
    print("Bienvenido /  Welcome")
    print("Please, choose your language / Por favor selecciona tu idioma")
    print("1) English")
    print("2) Espanol")
    
    option: str = utils.char()
  
    if option == "1": LANGUAGE=1
    elif option == "2": LANGUAGE=2
    else: exit(1)

def cover() -> None:
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
    print(r''':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::''')

def verify() -> None:

    if version_info < (3, 5):
        utils.clear(); printer("error",12); exit(1)
    if platform != "linux":
        utils.clear(); printer("error",0); exit(1)
    if not commandverify("udisksctl"):
        utils.clear(); printer("error",2); exit(1)
    if not commandverify("dialog"):
        utils.clear(); printer("error",3); exit(1)
        
    SERVICE: str = Popen('systemctl is-active udisks2', shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip('\n')
    
    if(SERVICE == "inactive"):
        utils.clear(); printer("error",4); exit(1)
        
    usbverify()
    printer("print",5)    
    
    spinner = utils.spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)  
        stdout.write('\b')

def usbverify() -> None:
    VERIFYUSB: str = Popen(r"""find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\/dev\/disk\/by-id\///'
                              """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip('\n')
    if(VERIFYUSB == ""): utils.clear(); printer("error", 6); exit(1)

def menu() -> None:
    choices = [
        (reader(13),reader(1)),(reader(14),reader(2)),
        (reader(15),reader(3)),(reader(16),reader(4))
    ]

    response = d.menu(reader(0), 15, 60, 4, choices)
    if(response[0] == "ok" and response[1] == reader(13)):
        usblistener("mount")
    elif(response[0] == "ok" and response[1] == reader(14)):
        usblistener("unmount")
    elif(response[0] == "ok" and response[1] == reader(15)):
        usblistener("off")
    elif(response[0] == "ok" and response[1] == reader(16)):
        utils.clear(); exit(0)
    else: utils.clear(); exit(0)

def usblistener(selector: str) -> None:
    utils.clear(); usbverify();
    
    COUNT: int = 0; PARTS: list = []; BLOCK: list = []; USB: list = [];
    FLAGS: list = []; FLAGS: list = []; MOUNTS: list = []
    UNMOUNTS: list = []; ARGS: list = []; ARGSPOWEROFF: list = []
    MOUNTCOUNT: int = 0; UNMOUNTCOUNT: int = 0; TYPE: str = ""; 
    MODEL: str = ""; FLAGSCOUNT: int = 0; DIRTYDEVS: list = []
    
    USB = Popen(r"""find /dev/disk/by-id/ -name 'usb*' | sort -n | sed 's/^\/dev\/disk\/by-id\///'
                              """, shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip().split('\n')
    
    for DEVICE in USB:
        DIRTYDEVS.append(Popen('''#!/bin/bash
                                   readlink "/dev/disk/by-id/''' +DEVICE+'''"''', shell=True, 
                                   stdout=PIPE).stdout.read().decode('utf-8')
                                    .rstrip().split("\n")[0])
        
    DIRTYDEVS = list(filter(('').__ne__, DIRTYDEVS))
    for DEV in DIRTYDEVS:
        ABSOLUTEPARTS = Popen(r"""#!/bin/bash
                             echo """+DEV+""" | sed 's/^\.\.\/\.\.\//\/dev\//' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'""", 
                             shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        
        if ABSOLUTEPARTS != "":
            PARTS.append(Popen(r"""#!/bin/bash
                                echo """+DEV+""" | sed 's/^\.\.\/\.\.\///' | sed '/.*[[:alpha:]]$/d' | sed '/blk[[:digit:]]$/d'""", 
                                shell=True, stdout=PIPE).stdout.read()
                                .decode('utf-8').rstrip().split("\n")[0]); COUNT += 1
        else:
            BLOCK.append(Popen(r"""#!/bin/bash
                                echo """+DEV+""" | sed 's/^\.\.\/\.\.\///'""", 
                                shell=True, stdout=PIPE).stdout.read()
                                .decode('utf-8').rstrip().split("\n")[0]); FLAGS.append(COUNT)

    for PARTITIONS in PARTS:
        MOUNTED: str = Popen("lsblk /dev/"+PARTITIONS+" | sed -ne '/\//p'", shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
        if(MOUNTED != ""): UNMOUNTCOUNT += 1; MOUNTS.append(PARTITIONS)
        else: MOUNTCOUNT += 1; UNMOUNTS.append(PARTITIONS)
        
    if(selector == "mount"):
        if(UNMOUNTCOUNT == COUNT): printer("error",7); input(reader(5)); menu(); return
        COUNT=0
        for PART in UNMOUNTS:
            DEVICE: str = "/dev/"+PART
            TYPE: str = Popen(r'''#!/bin.bash
                 lsblk -f /dev/'''+PART+''' | sed -ne '2p' | cut -d " " -f2''',
                 shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            TEMP = FLAGS[FLAGSCOUNT]
            if(COUNT == TEMP): BLOCKSTAT = BLOCK[FLAGSCOUNT]; FLAGSCOUNT += 1
            MODEL: str = Popen(r'''#!/bin.bash
                 cat /sys/class/block/'''+BLOCKSTAT+'''/device/model''',
                 shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGS.append([DEVICE, MODEL + " " + TYPE])
        response = d.menu(reader(6), 15, 50, 4, ARGS)
        if(response[0] == "ok"):
            mountaction(response[1])
        else: utils.clear(); menu()
        
    elif(selector == "unmount"):
        if(MOUNTCOUNT == COUNT): printer("error",10); input(reader(5)); menu(); return
        COUNT=0
        for PART in MOUNTS:
            DEVICE: str = "/dev/"+PART
            TYPE: str = Popen(r'''#!/bin.bash
                 lsblk -f /dev/'''+PART+''' | sed -ne '2p' | cut -d " " -f2''',
                 shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            TEMP = FLAGS[FLAGSCOUNT]
            if(COUNT == TEMP): BLOCKSTAT = BLOCK[FLAGSCOUNT]; FLAGSCOUNT += 1
            MODEL: str = Popen(r'''#!/bin.bash
                 cat /sys/class/block/'''+BLOCKSTAT+'''/device/model''',
                 shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGS.append([DEVICE, MODEL + " " + TYPE])
        response = d.menu(reader(9), 15, 50, 4, ARGS)
        if(response[0] == "ok"):
            unmountaction(response[1])
        else: utils.clear(); menu()
        
    elif(selector == "off"):
        COUNT=0
        for PART in BLOCK:
            DEVICE: str = "/dev/"+PART
            BLOCKSTAT = BLOCK[COUNT]
            MODEL: str = Popen(r'''#!/bin.bash
                 cat /sys/class/block/'''+BLOCKSTAT+'''/device/model''',
                 shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
            ARGSPOWEROFF.append([DEVICE, MODEL])
            COUNT += 1
            
        response = d.menu(reader(11), 15, 50, 4, ARGSPOWEROFF) 
        if(response[0] == "ok"):
            poweroffaction(response[1])
        else: utils.clear(); menu()

def mountaction(part: str) -> None:

    utils.clear()
    if (part == ""): return
    try:
        DATAMOUNT = check_output("udisksctl mount -b " + part, shell=True, stderr=PIPE)
    except CalledProcessError as err: 
        print(err.stderr.decode("utf-8"))
        if (search("NotAuthorized*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",8); input(reader(5)); menu()
        if (search("NotAuthorizedDismissed*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",8); input(reader(5)); menu()        
        elif (search("AlreadyMounted*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",9); input(reader(5)); menu()
    else:   
        d.msgbox(reader(8)+DATAMOUNT.decode("utf-8"),7,35); menu()

def unmountaction(part: str) -> None:
    
    utils.clear()
    if (part == ""): return
    try:
        DATAMOUNT = check_output("udisksctl unmount -b " + part, shell=True, stderr=PIPE)
    except CalledProcessError as err: 
        print(err.stderr.decode("utf-8"))
        if (search("NotAuthorized*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",8); input(reader(5)); menu()
        if (search("NotAuthorizedDismissed*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",8); input(reader(5)); menu()        
        elif (search("AlreadyMounted*",err.stderr.decode("utf-8"))):
            utils.clear(); printer("error",9); input(reader(5)); menu()
    else:   
        d.msgbox(reader(8)+DATAMOUNT.decode("utf-8"),7,35); menu()

def poweroffaction(part: str) -> None:
    utils.clear()
    if (part == ""): return
    
    BLOCKTEMP: str = Popen(r'''#!/bin/bash
                             echo '''+part+''' | cut -d "/" -f3''', 
                             shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
    
    PARTITIONSQUERY: list = Popen("""#!/bin/bash
                                   find /dev -name \"""" +BLOCKTEMP+ """[[:digit:]]\" | sort -n | sed 's/^\/dev\///'""", shell=True, 
                                   stdout=PIPE).stdout.read().decode('utf-8').rstrip().split("\n")
    
    for PARTITION in PARTITIONSQUERY:
        check_output('udisksctl unmount -b "/dev/'+PARTITION+'" &> /dev/null', shell=True, stderr=PIPE)
        spinner = utils.spinning()
        for _ in range(10):
            stdout.write(next(spinner))
            stdout.flush(); sleep(0.1)  
            stdout.write('\b')
            
    MODEL: str = Popen(r'''#!/bin.bash
                cat /sys/class/block/'''+BLOCKTEMP+'''/device/model''',
                shell=True, stdout=PIPE).stdout.read().decode('utf-8').rstrip()
    
    check_output('udisksctl power-off -b ' + part, shell=True, stderr=PIPE)

    if(LANGUAGE == 1): 
        d.msgbox("SUCCESS: Your device "+MODEL+" was succesfully power-off",7,35)
        menu()
    else:
        d.msgbox("LISTO: Tu dispositivo "+MODEL+" se ha apagado exitosamente",7,35)
        menu()
        
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
    
    def spinning():
        while True:
            for cursor in '|/-\\':
                yield cursor

if __name__ == "__main__":
    main()