# 036utils

TUI Utilites for GNU/Linux and macOS with Bash and Python

![Alt text](brandwhite.png?raw=true "Title")

## Prerequisites of use

- Basic or medium understanding of GNU/Linux
- Some binaries, depending on the application
- For Python scripts, you need Python 3.5 or above

## Description of every script

- efitoggler: Mount or unmount a efi partition, like a toggle switch (Only runs in macOS)
- usb-manager: Dialog-based application that has several options like mount, unmount and poweroff USB devices (Only runs in GNU/Linux).
  - You need the next binaries `dialog udisks2`
- ext4-optimizer: Dialog-based application that defrag and optimize ext4 filesystem (Only runs in GNU/Linux).
  - You need the next binaries `dialog e4defrag`
- rsyncer: Dialog-based simple application that copy all contents from a source directory to a destination directory, it's recommended to copy root filesystems (Only runs in GNU/Linux).
  - You need the next binaries `dialog rsync`

## Also Python?

- I recommend to use python scripts, works at 100% similar than bash scripts, the performance in python is better
- Static typing is enabled by default, please run your scripts with python3 only
- Only one module is required, please install pythondialog locally

```bash
$ pip install pythondialog
```

## Installation and usage

- Clone this repository
  - `git clone https://github.com/victor7w7r/036utils`

- Choose your favourite script and run

```bash
$ cd 036utils/python
$ python3 ext4-optimizer.py
```

- For bash scripts, give the right permissions and run

```bash
$ cd 036shell/shell
$ chmod +x ext4-optimizer
$ ./ext4-optimizer
```

## TODO

- [ ] More Code Optimization

## Development Suite

- Editor: [vscode](https://code.visualstudio.com/)
- Lint and Syntax Check: [ShellCheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck), [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
- Operating Systems for tests: [Arch Linux ARM](https://archlinuxarm.org/), [Kali Linux](https://www.kali.org/)
