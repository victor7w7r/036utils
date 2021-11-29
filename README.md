# 036shell

Shell Utilites for GNU/Linux and macOS

![Alt text](brandwhite.png?raw=true "Title")

## Prerequisites of use

- Basic or medium understanding of GNU/Linux
- Some binaries, depending on the application

## Description of every script

- efitoggler: Mount or unmount a efi partition, like a toggle switch (Only runs in macOS)
- usb-manager: Dialog-based application that has several options like mount, unmount and poweroff USB devices (Only runs in GNU/Linux).
  - You need the next binaries `dialog udisks2`
- ext4-optimizer: Dialog-based application that defrag and optimize ext4 filesystem.
  - You need the next binaries `dialog e4defrag`
- rsyncer: Dialog-based simple application that copy all contents from a source directory to a destination directory, it's recommended to copy root filesystems
  - You need the next binaries `dialog rsync`

## Installation and usage

- Clone this repository
  - `git clone https://github.com/victor7w7r/036shell`

- Choose your favourite script, give the right permissions and run

```bash
$ cd 036shell
$ chmod +x ext4-optimizer
$ ./ext4-optimizer
```

## Spanish Folder?

I born and live in Ecuador, of course i made a spanish scripts version, sorry for my bad english. :blush:

## TODO

- [ ] Code Optimization

## Development Suite

- Editor: [vscode](https://code.visualstudio.com/)
- Lint and Syntax Check: [ShellCheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)
- Operating System Test: [Arch Linux ARM](https://archlinuxarm.org/)

## Thanks at this repositories for code snippets

- [Desktopify](https://github.com/wimpysworld/desktopify) (Convert Ubuntu Server for Raspberry Pi to a Desktop.)
- [ZeroTierOne](https://github.com/zerotier/ZeroTierOne) (Free VPN)
