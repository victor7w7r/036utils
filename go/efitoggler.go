package main

import (
	"036utils/utils"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"time"
	"strings"

	"github.com/briandowns/spinner"
	"github.com/fatih/color"
)

func core() {
	utils.Clear()
	language()
	cover()
	verify()
	toggler()
}

var LANGUAGE = 0

func printer(typeQuery string, position int) {

	DICTIONARY_ENG := [7]string{
		"Your Operating System is not macOS, exiting",
		"All dependencies is ok!",
		"EFI Folder is mounted, unmounting",
		"EFI Folder is not mounted, mounting",
		"Done!",
		"Sudo auth fails",
	}

	DICTIONARY_ESP := [7]string{
		"Tu sistema operativo no es macOS, saliendo",
		"¡Todo ok!",
		"La carpeta EFI esta montada, desmontando",
		"La carpeta EFI no esta montada, montando",
		"¡Listo!",
		"Autenticación con sudo falló",
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
		fmt.Print("\n")
		os.Exit(1)
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
	if platform != "darwin" {
		utils.Clear()
		printer("error", 0)
		fmt.Print("\n")
		os.Exit(1)
	}
	printer("print", 1)
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)
	s.Start()
	time.Sleep(time.Second)
	s.Stop()
}

func toggler() {

	sout1, err1 := exec.Command("bash", "-c", 
		"diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p'").Output()
	if err1 != nil {fmt.Println(err1); os.Exit(1)}

	sout2, err2 := exec.Command("bash", "-c", 
		"EFIPART=$(diskutil list | sed -ne '/EFI/p' | sed -ne 's/.*\\(d.*\\).*/\\1/p') MOUNTROOT=$(df -h | sed -ne \"/$EFIPART/p\"); echo $MOUNTROOT").Output()
	if err2 != nil {fmt.Println(err2); os.Exit(1)}

	EFIPART, EFI := string(sout1), string(sout2)

	EFIPART = strings.TrimSuffix(EFIPART, "\n") 
	EFI = strings.TrimSuffix(EFI, "\n") 

	if EFI != "" {
		printer("print", 2)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			fmt.Print(outChck)
		 	exec.Command("bash", "-c", fmt.Sprintf("sudo diskutil unmount %s",EFIPART)).Run()
			exec.Command("bash", "-c", "sudo rm -rf /Volumes/EFI").Run()
			utils.Clear()
			printer("print", 4)
		} else {
			utils.Clear()
			printer("print", 6)
			fmt.Printf("\n")
			os.Exit(1)
		}
	} else {
		printer("print", 3)
		checkDev := exec.Command("bash", "-c", "sudo cat < /dev/null")
		checkDev.Stdin = os.Stdin
		outChck, errChck := checkDev.Output()
		if errChck == nil {
			fmt.Print(outChck)
			exec.Command("bash", "-c", "sudo mkdir /Volumes/EFI").Run()
			exec.Command("bash", "-c", fmt.Sprintf("sudo mount -t msdos /dev/%s /Volumes/EFI", EFIPART)).Run()
			exec.Command("bash", "-c", "open /Volumes/EFI").Run()
			utils.Clear()
			printer("print", 4)
		} else {
			utils.Clear()
			printer("print", 6)
			fmt.Print("\n")
			os.Exit(1)
		}
	}

}

func main() { core() }
