package main

import (
	"036utils/utils"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"time"

	"github.com/briandowns/spinner"
	"github.com/fatih/color"
)

func core() {
	utils.Clear(); language(); cover();
}

var LANGUAGE int = 0
var SOURCE string = ""
var DEST string = ""

func printer(typeQuery string, position int, additional ...string) {

	DICTIONARY_ENG := [10]string{
		"Your Operating System is not GNU/Linux, exiting",
		"In this system the binary sudo doesn't exist.",
		"The rsync binary is not available in this system, please install",
		"The dialog binary is not available in this system, please install",
		"All dependencies is ok!",
		fmt.Sprintf("The directory %s doesn't exist", additional),
		"=============== START RSYNC =============== \n" ,
		"Done!\n",
		"You don't have permissions to write the destination or read the source",
		"=============== FAIL =============== \n",
	}

	DICTIONARY_ESP := [10]string{
		"Este sistema no es GNU/Linux, saliendo",
		"En este sistema no existe el binario de superusuario.",
		"El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
		"EL ejecutable de dialog, no se encuentra en el sistema, por favor instalalo",
		"¡Todo ok!",
		fmt.Sprintf("El directorio %s no existe", additional),
		"=============== EMPEZAR RSYNC =============== \n" ,
		"Listo!\n",
		"No tienes permisos para escribir el directorio de destino o para leer el origen",
		"=============== FALLA =============== \n",
	}

	green := color.New(color.FgGreen)
	cyan := color.New(color.FgCyan)
	red := color.New(color.FgRed)

	if LANGUAGE == 1 {
		switch {
		case typeQuery == "print":
			fmt.Println(DICTIONARY_ENG[position])
		case typeQuery == "info":
			green.Print("[+] ")
			fmt.Printf("INFO: %s", DICTIONARY_ENG[position])
		case typeQuery == "warn":
			cyan.Print("[*] ")
			fmt.Printf("WARNING: %s", DICTIONARY_ENG[position])
		case typeQuery == "error":
			red.Print("[!] ")
			fmt.Printf("ERROR: %s", DICTIONARY_ENG[position])
		}
	} else {
		switch {
		case typeQuery == "print":
			fmt.Println(DICTIONARY_ESP[position])
		case typeQuery == "info":
			green.Print("[+] ")
			fmt.Printf("INFO: %s", DICTIONARY_ESP[position])
		case typeQuery == "warn":
			cyan.Print("[*] ")
			fmt.Printf("WARNING: %s", DICTIONARY_ESP[position])
		case typeQuery == "error":
			red.Print("[!] ")
			fmt.Printf("ERROR: %s", DICTIONARY_ESP[position])
		}
	}
}

func reader(position int) string {

	DICTIONARY_ENG:= [3]string {
		"Please write your source directory",
		"Please write your destination directory to copy",
		"Press Enter to continue...",
	}

	DICTIONARY_ESP:= [3]string {
		"Por favor escriba su directorio de origen",
		"Por favor escriba su directorio de destino",
		"Presione Enter para continuar...",
	}

	if(LANGUAGE == 1) {
		return DICTIONARY_ENG[position]
	} else {
		return DICTIONARY_ESP[position]	
	}
}

func commandverify(cmd string) bool {
	check := exec.Command("bash", "-c", fmt.Sprintf("type %s",cmd))
	_, err := check.Output();

	if(err == nil) {
		return true
	} else {
		return false
	}
} 

func language() {

	fmt.Println("Bienvenido / Welcome")
	fmt.Println("Please, choose your language / Por favor selecciona tu idioma")
	fmt.Println("1) English")
	fmt.Println("2) Espanol")

	option := utils.Char()

	if option == 1 {
		LANGUAGE = 1
	} else if option == 2 {
		LANGUAGE = 2
	} else {
		fmt.Print("\n"); os.Exit(1)
	}
}

func cover() {
	utils.Clear()
	fmt.Println("                                    `\"~>v??*^;rikD&MNBQku*;`                                           ")
	fmt.Println("                                `!{wQNWWWWWWWWWWWWWWWNWWWWWWNdi^`                                       ")
	fmt.Println("                              .v9NWWWWNRFmWWWWWWWWWWWWga?vs0pNWWWMw!                                    ")
	fmt.Println("                            !9WWWWWWU>`>&WWWWWWUH!_JNWWWWWQz  ^EWWWWg|                                  ")
	fmt.Println("                           _SWWWWWNe: /RWWWWWWNNHBRuyix&WWWWWg2?-\"VNWWW6_                              ")
	fmt.Println("                         \"kWWWWWNz. .zNWWWWWWw=, ^NsLQNW**MWWWW&WQJuNWWWNr.                            ")
	fmt.Println("                       .FNWWWWNu. rL&WWWWWWg!!*;^Jo!*BN0aFx)>|!;;;;;!~/r)xFwaao?|,                      ")
	fmt.Println("                     .sNWWWWMi` -,#WWWWWWNi\"` Siwu UWv  .;^|^;`               .!*lUSF*;                ")
	fmt.Println("                    )BWWWWWo.   9NWWWWWW0; ;PvLc*aU&^ |L=-``.;>*=                   ;)wmkL_             ")
	fmt.Println("                  _QWWWWWq\"   .aWWWWWWWs`  rF<>/^gQ, /i   ,;;.  !2                      ,*k0F/`        ")
	fmt.Println("                 *NWWWWNv   ,/&WWWWWWNr \"!SL92l)BU.  ^x   x. L,  I_                        `>P&F;      ")
	fmt.Println("               `2WWWWWg;    !BWWWWWWD\"   .s;!/xNa     /L,   !L`  P,                           .?&gr     ")
	fmt.Println("              ,QWWWWWS`  >;LWWWWWWWk`_;!/u|  ^Ml        ;~!^,  `iv                              `?Ng^   ")
	fmt.Println("             ^BWWWWWi   *i7NWWWWWWc \"a;;?ii\"~NV             `;?},                                 ,9WF  ")
	fmt.Println("            >WWWWWB!  ` ;8WWWWWWM=  r>`;F/2wNc          .;||!,                                      oW#.")
	fmt.Println("           ?WWWWW#\"  `2;7NWWWWW&_ =_=u%ir`>Wi                                                        PW6")
	fmt.Println("          rWWWWWc   `||>WWWWWWU.  r^?7;!v*W)                                                         ,WW|")
	fmt.Println("         ^NWWWB!  ! /jrmWWWWWw  `vL.k*/vkW$>rr*r;`        ;rL{7)>!`                                   mWF")
	fmt.Println("         .BWWW$,   ,u. PWWWWW) ,r`)|)!__LWv     `;L\"     |s>:```._|JuL                                 qWE")
	fmt.Println("        uWWWH` .vi\"Fo*WWWWN>   ^v  r*`>W}                                                             &Ws ")
	fmt.Println("        ;WWWP`  `=*ox_pWWWB; ^)i`9xr,#7W*            .     ,/*`                                       |WW!")
	fmt.Println("       SWWD` >LLr^_y*NWWQ\"  ,<?P~|iF0W}            ~;   v_ `o;                                      .0WU")
	fmt.Println("      ^WW0,.!F2xULFi5WW0` >7vr!!z_`*Wv             `|;;^!,~!`                                      .8W8.")
	fmt.Println("      dWN;`>JyrkIr`!NWN! ,uFia!9?*2WI                                                             ;QWD.")
	fmt.Println("     =WW7`_S)~Fxv| xWWi ;}drqa=;=uWRNmL,                                                         rWWt`")
	fmt.Println("     DWP`;LiL;}c*rsWW&`,Po_e7L/ =Nc `>oD$aawTouic7)*r>=|^^~!;;;;;;;;;;;;;~^/>rvL{JctxiiiiuusoF2kgBS/ ")
	fmt.Println("    ;WN\\Uy>*rF.,pWWWr-;?J}\"vov^^Nu         `.,\"_;!~^/=>r*v?LL{}Jjjjjjj}}7?vr>/^!;____-\"\"\",,,..``    ")
	fmt.Println("    iW?_**>^;>\"~&EeWg=|liv*s!~?NL")
	fmt.Println("    wWc*$>*~~L6Ni QW! /Uursx >WJ")
	fmt.Println("    2M)o*_F \"R0; .Wd~U7,``;*iN>")
	fmt.Println("    xWe?vI7cMu`  ,W&>xssr~=PB|")
	fmt.Println("    \"WY ,cBZ_    `M2l//i,,QQ,")
	fmt.Println("     |U$di_       UBu>i)yBy`")
	fmt.Println("                  ^Wx,rDR!")
	fmt.Println("                   /ZUl^")
	fmt.Println(".oPYo. .oPYo. .pPYo.   .oPYo.                       o   o                 .oPYo.   o              8  o                ")
	fmt.Println("8  .o8     `8 8        8    8                       8                     8        8              8                   ")
	fmt.Println("8 .P`8   .oP` 8oPYo.   8      oPYo. .oPYo. .oPYo.  o8P o8 o    o .oPYo.   `Yooo.  o8P o    o .oPYo8 o8 .oPYo. .oPYo.  ")
	fmt.Println("8.d` 8    `b. 8`  `8   8      8  `` 8oooo8 .oooo8   8   8 Y.  .P 8oooo8       `8   8  8    8 8    8  8 8    8 Yb..   ")
	fmt.Println("8o`  8     :8 8.  .P   8    8 8     8.     8    8   8   8 `b..d` 8.            8   8  8    8 8    8  8 8    8   `Yb. ")
	fmt.Println("`YooP` `YooP` `YooP`   `YooP` 8     `Yooo` `YooP8   8   8  `YP`  `Yooo`   `YooP`   8  `YooP` `YooP`  8 `YooP` `YooP. ")
	fmt.Println(":.....::.....::.....::::.....:..:::::.....::.....:::..::..::...:::.....::::.....:::..::.....::.....::..:.....::.....:")
	fmt.Println(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
	fmt.Println(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
}

func verify() {
	platform := runtime.GOOS
	if platform != "linux" {
		utils.Clear(); printer("error", 0)
		fmt.Print("\n"); os.Exit(1)
	}
	if(!commandverify("rsync")) {
		utils.Clear(); printer("error", 2)
		fmt.Print("\n"); os.Exit(1)
	}
	if(!commandverify("dialog")) {
		utils.Clear(); printer("error", 3)
		fmt.Print("\n"); os.Exit(1)
	}
	printer("print",4)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start(); time.Sleep(time.Second); s.Stop()

	utils.Clear();
}

func validator(typeData string, data string) {

	if typeData == "source" {

		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				SOURCE=data;  destiaction();
				return
			} else {
				utils.Clear(); printer("error", 5, data)
				fmt.Println(reader(2)); fmt.Scanln()
				sourceaction(); return
			}
		} else {
			fmt.Print("\n"); os.Exit(0)
		}

	} else if typeData == "dest" {
		
		if data != "" {
			_, err := os.Stat(data)
			if err == nil {
				DEST=data;  syncer();
				return
			} else {
				utils.Clear(); printer("error", 6, data)
				fmt.Println(reader(2)); fmt.Scanln()
				sourceaction(); return
			}
		} else {
			utils.Clear(); printer("error", 5, data)
			fmt.Println(reader(2)); fmt.Scanln()
			sourceaction(); return
		}
	} else {
		fmt.Print("\n"); os.Exit(0)
	}

}

func sourceaction() {

}

func destiaction() {

}

func syncer() {

}


func main() { core() }