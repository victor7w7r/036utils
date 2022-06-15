package utils

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"

	"golang.org/x/term"
)

func Clear() {
	cmd := exec.Command("clear")
	cmd.Stdout = os.Stdout
	cmd.Run()
}

func Char() int {
	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		fmt.Println(err)
		return 0
	}

	defer term.Restore(int(os.Stdin.Fd()), oldState)

	b := make([]byte, 1)
	_, err = os.Stdin.Read(b)
	if err != nil {
		fmt.Println(err)
		return 0
	}

	number, err := strconv.Atoi(string(b[0]))

	if err != nil {
		fmt.Println(err)
		return 0
	}

	return number
}
