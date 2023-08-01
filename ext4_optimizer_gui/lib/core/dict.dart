// ignore_for_file: lines_longer_than_80_chars
const _dictEsp = [
  'Necesitas ser superusuario, por favor ejecuta con sudo',
  'El ejecutable e4defrag no está presente en tu sistema, por favor instalalo',
  'fsck.ext4 no está presente en tu sistema, por favor instalalo',
  'No hay particiones ext4 disponibles en el sistema, solo funciona con dispositivos USB',
  'Todas las particiones ext4 estan montadas en el sistema, por favor desmontar la particion deseada para optimizar',
  'Por favor elige una particion para optimizar',
  '¡Vamos!',
  '¿Quieres optimizar la particion ',
  'Cancelar',
  'Salir',
  'No se pudo descargar la aplicación auxiliar, verifique su conexión al internet',
  'La operación a finalizado, puedes salir',
  'El ejecutable zenity no está presente en tu sistema, por favor instalalo'
];

const _dictEng = [
  'You need to be root, please execute with sudo',
  'e4defrag binary is not present in this system, please install',
  'fsck.ext4 is not present in this system, please install',
  "There's not ext4 partitions available, only works with USB devices",
  'All the ext4 partitions are mounted in your system, please unmount the desired partition to optimize',
  'Please choose a partition for optimize',
  "Let's go!",
  'Do you want to optimize de partition ',
  'Cancel',
  'Exit',
  'The auxiliary application could not be downloaded, please check your internet connection',
  'The operation was finished, you can exit',
  'zenity binary is not present in this system, please install'
];

String dict(
  final int index,
  final bool isEng
) => isEng
  ? _dictEsp[index] : _dictEng[index];
