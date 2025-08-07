//go:build windows
// +build windows

package vault

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"syscall"
)

func executeMFACommand(processCmd string) (string, error) {
	// On windows, its quite involved to launch a process if the binary involved is in a path with spaces
	// See https://github.com/golang/go/issues/17149 for details and workaround proposals
	shell := os.Getenv("SystemRoot") + "\\System32\\cmd.exe"
	cmd := exec.Command(shell)
	cmd.SysProcAttr = &syscall.SysProcAttr{CmdLine: "/C \"" + processCmd + "\""}
	cmd.Stderr = os.Stderr

	out, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("process provider: %w", err)
	}

	return strings.TrimSpace(string(out)), nil
}
