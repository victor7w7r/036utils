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
- rsyncer: Dialog-based simple application that copy all contents from a source directory to a destination directory, it's recommended to copy root filesystems (Only runs in GNU/Linux).
  - You need the next binaries `rsync`

## Debug and Compile

- Install your sdks

```bash
$ yay -S dart  #Archlinux with yay (AUR)
$ brew install --cask dart-sdk  #macOS
```

- Clone this repository
  - `git clone https://github.com/victor7w7r/036utils`

- Choose your flavour lang and initialize the packages

```bash
$ cd 036utils/efitoggler
$ dart pub get
```

- Run your favourite app

```bash
$ cd 036utils/efitoggler/bin
$ dart efitoggler.dart
```

- And compile your app

```bash
$ cd 036utils/efitoggler/bin
$ dart compile exe efitoggler.dart -o efitoggler
```

## Development Suite

- Editor: [vscode](https://code.visualstudio.com/)
- Lint and Syntax Check: [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
- Operating Systems for tests: [Arch Linux](https://archlinux.org/)
