# 036utils

TUI Utilites for GNU/Linux and macOS with Bash and Python

![Alt text](brandwhite.png?raw=true "Title")

## Prerequisites of use

- Basic or medium understanding of GNU/Linux
- Some binaries, depending on the application
- For Python binaries, you need Python 3.5 or above
- For reading the code, understanding of Go, Dart and Python

## Description of every script

- efitoggler: Mount or unmount a efi partition, like a toggle switch (Only runs in macOS)
- usb-manager: Dialog-based application that has several options like mount, unmount and poweroff USB devices (Only runs in GNU/Linux).
- ext4-optimizer: Dialog-based application that defrag and optimize ext4 filesystem (Only runs in GNU/Linux).
  - You need the next binaries `dialog e4defrag`
- rsyncer: Dialog-based simple application that copy all contents from a source directory to a destination directory, it's recommended to copy root filesystems (Only runs in GNU/Linux).
  - You need the next binaries `dialog rsync`

## Running

- First clone this repository
  - `git clone https://github.com/victor7w7r/036utils`

- Choose your favorite flavour lang and run your favourite app

```bash
$ cd 036utils
$ ./bin/dart/efitoggler
```

## Debug and Compile

- Install your sdks

```bash
$ pacman -S dart-sdk go python3 python-pipenv #Archlinux
$ brew -S dart-sdk go python3 pipenv #macOS
```

- Clone this repository
  - `git clone https://github.com/victor7w7r/036utils`

- Choose your flavour lang and initialize the packages

```bash
# Python
$ cd 036utils/src/efitoggler/py
$ pipenv sync

# Dart
$ cd 036utils/src/efitoggler/dart
$ dart pub get

# Go
$ cd 036utils/src/efitoggler/go
$ go get -v
```

- Run your favourite main script

```bash
# Python
$ cd 036utils/src/efitoggler/py
$ pipenv run python efitoggler.py

# Dart
$ cd 036utils/src/efitoggler/dart/bin
$ dart efitoggler.dart

# Go
$ cd 036utils/src/efitoggler/go
$ go run efitoggler.go
```

- And compile your app

```bash
# Python
$ cd 036utils/src/efitoggler/py
$ pipenv run pyinstaller --onefile efitoggler.py
$ ./dist/efitoggler

# Dart
$ cd 036utils/src/efitoggler/dart/bin
$ dart compile exe efitoggler.dart -o efitoggler
$ ./efitoggler

# Go
$ cd 036utils/src/efitoggler/go
$ go build
$ ./efitoggler
```

## Development Suite

- Editor: [vscode](https://code.visualstudio.com/)
- Lint and Syntax Check: [Pylance](https://marketplace.visualstudio.com/,items?itemName=ms-python.vscode-pylance), [Go](https://code.visualstudio.com/docs/languages/go), [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- Operating Systems for tests: [Arch Linux](https://archlinux.org/)
