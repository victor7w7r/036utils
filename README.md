# 036utils

Utilites for GNU/Linux and macOS

![Alt text](brandwhite.png?raw=true "Title")

## Prerequisites of use

- Basic or medium understanding of GNU/Linux
- Some binaries, depending on the application
- For reading the code, understanding of Dart and Flutter

## Description of every app for CLI and GUI

- efitoggler: Mount or unmount a efi partition, like a toggle switch (Only runs in macOS)
- usb-manager: Dialog-based application that has several options like mount, unmount and poweroff USB devices (Only runs in GNU/Linux).
- ext4-optimizer: Dialog-based application that defrag and optimize ext4 filesystem (Only runs in GNU/Linux).
  - You need the next binaries `e4defrag`
- rsyncer: Dialog-based simple application that copy all contents from a source directory to a destination directory, it's recommended to copy root filesystems (Only runs in GNU/Linux).
  - You need the next binaries `rsync`

## Architecture

Flutter apps was made with the 036 Architecture for Flutter

![Alt text](flutterarch.png?raw=true "Title")

## Debug and Compile

- Install your sdks

```bash
$ yay -S flutter  #Archlinux with yay (AUR)
$ brew install --cask flutter  #macOS
```

- Clone this repository
  - `git clone https://github.com/victor7w7r/036utils`

- Choose your flavour lang and initialize the packages

```bash
# Dart
$ cd 036utils/efitoggler_cli
$ dart pub get

# Flutter
$ cd 036utils/efitoggler_cli
$ flutter pub get
```

- Run your favourite app

```bash
# Dart
$ cd 036utils/efitoggler_cli/bin
$ dart efitoggler_cli.dart

# Flutter
$ cd 036utils/efitoggler_gui
$ flutter run
```

- And compile your app

```bash
# Dart
$ cd 036utils/efitoggler_cli/bin
$ dart compile exe efitoggler_cli.dart -o efitoggler_cli

# Flutter
$ cd 036utils/efitoggler_gui
$ flutter build
```

## Development Suite

- Editor: [vscode](https://code.visualstudio.com/)
- Lint and Syntax Check: [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- Operating Systems for tests: [Arch Linux](https://archlinux.org/)
