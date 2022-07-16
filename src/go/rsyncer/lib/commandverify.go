package lib

import (
	"fmt"
	"os/exec"
)

func Commandverify(cmd string) bool {
	check := exec.Command("bash", "-c", fmt.Sprintf("type %s",cmd))
	_, err := check.Output();

	if(err == nil) {
		return true
	} else {
		return false
	}
}
