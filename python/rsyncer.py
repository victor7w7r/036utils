from subprocess import call, PIPE
from sys import stdout, platform, version_info
from os import system, path
from re import search
from time import sleep
from pip import main

try:
    inquirer = __import__('inquirer')
except ImportError:
    main(['install', 'inquirer'])
    inquirer = __import__('inquirer')

SOURCE: str = ""; DEST: str = ""; LANGUAGE: int = 0

def core() -> None: utils.clear(); language(); cover(); verify()

def printer(type: str, position: int, additional: str = "") -> None:

    GREEN = '\033[92m';  WARNING = '\033[93m'; FAIL = '\033[91m';  ENDC = '\033[0m'

    DICTIONARY_ENG=(
        "Your Operating System is not GNU/Linux, exiting",
        "In this system the binary sudo doesn't exist.",
        "The rsync binary is not available in this system, please install",
        "The dialog binary is not available in this system, please install",
        "All dependencies is ok!",
        f"The directory {additional} doesn't exist",
        "=============== START RSYNC =============== \n" ,
        "Done!\n",
        "Your Python versión is less than 3.5, exiting",
        "You don't have permissions to write the destination or read the source",
        "=============== FAIL =============== \n"
    )

    DICTIONARY_ESP=(
        "Este sistema no es GNU/Linux, saliendo",
        "En este sistema no existe el binario de superusuario.",
        "El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
        "EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
        "¡Todo ok!",
        f"El directorio {additional} no existe",
        "=============== EMPEZAR RSYNC =============== \n" ,
        "Listo!\n",
        "Tu versión de Python es menor que 3.5, saliendo",
        "No tienes permisos para escribir el directorio de destino o para leer el origen",
        "=============== FALLA =============== \n"
    )

    if LANGUAGE == 1 :
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
		"Please write your source directory",
		"Please write your destination directory to copy",
		"Press Enter to continue...",
	)

    DICTIONARY_ESP=(
		"Por favor escriba su directorio de origen",
		"Por favor escriba su directorio de destino",
		"Presione Enter para continuar..."
	)

    if LANGUAGE == 1 : return DICTIONARY_ENG[position]
    else: return DICTIONARY_ESP[position]

def commandverify(cmd: str) -> bool:
    return call("type " + cmd, shell=True, stdout=PIPE, stderr=PIPE) == 0

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
    print(r''':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::''')

def verify() -> None:

    if version_info < (3, 5):
        utils.clear(); printer("error",8); exit(1)
    if platform != "linux":
        utils.clear(); printer("error",0); exit(1)
    if not commandverify("rsync"):
        utils.clear(); printer("error",2); exit(1)
    if not commandverify("dialog"):
        utils.clear(); printer("error",3); exit(1)
    printer("print",4)
    spinner = utils.spinning()
    for _ in range(15):
        stdout.write(next(spinner))
        stdout.flush(); sleep(0.1)
        stdout.write('\b')

    utils.clear(); sourceaction()

def validator(type: str, data: str) -> None:

    global SOURCE; global DEST

    if type == "source":
        if data != "":
            if path.exists(data):
                SOURCE=data; utils.clear(); destiaction()
                return
            else:
                utils.clear(); printer("error", 5, data)
                input(reader(2)); utils.clear(); sourceaction()
        else: exit(0)
    elif type == "dest":
        if data != "":
            if path.exists(data):
                DEST=data; utils.clear(); syncer(); return
            else:
                utils.clear(); printer("error", 5, data)
                input(reader(2)); utils.clear(); destiaction()
                return
        else: sourceaction()
    else: exit(0)

def sourceaction() -> None:

    q = [inquirer.Text('source', message=reader(0))]
    data = inquirer.prompt(q)
    validator("source", data['source'])

def destiaction() -> None:

    q = [inquirer.Text('dest', message=reader(1))]
    data = inquirer.prompt(q)
    validator("dest", data['dest'])

def syncer() -> None:

    SOURCEREADY: str=""; DESTREADY: str = ""
    if search(".*\/$", SOURCE): SOURCEREADY = SOURCE
    else: SOURCEREADY = SOURCE + '/'
    if search(".*\/$", DEST): DESTREADY = DEST
    else: DESTREADY = DEST + '/'

    utils.clear(); printer("print",6)
    print(f"SOURCE:{SOURCEREADY}"); print(f"DESTINATION:{DESTREADY}")

    if call(f"rsync -axHAWXS --numeric-ids --info=progress2 {SOURCEREADY} {DESTREADY}", shell=True) == 0:
        print("\n =============== OK =============== \n" )
        printer("print",7); exit(0)
    else:
        utils.clear(); printer("print",9)
        print(f"SOURCE:{SOURCEREADY}"); print(f"DESTINATION:{DESTREADY}")
        if call(f"sudo rsync -axHAWXS --numeric-ids --info=progress2 {SOURCEREADY} {DESTREADY}", shell=True) == 0:
            print("\n =============== OK =============== \n" )
            printer("print",7); exit(0)
        else: printer("print",10); exit(1)

class utils:

    def clear() -> None: system('clear')

    def spinning():
        while True:
            for cursor in '|/-\\':
                yield cursor

if __name__ == "__main__": core()