//go:build linux || darwin || freebsd || openbsd
// +build linux darwin freebsd openbsd

package vault

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func executeMFACommand(processCmd string) (string, error) {
	cmd := exec.Command("/bin/sh", "-c", processCmd)
	cmd.Stderr = os.Stderr

	out, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("process provider: %w", err)
	}

	return strings.TrimSpace(string(out)), nil
}
