// ignore_for_file: lines_longer_than_80_chars
const _dictEsp = [
  'Necesitas ser superusuario, por favor ejecuta con sudo',
  "El 'udisks command line tool (udisksctl)' no existe, por favor instale udisks2",
  'El servicio udisks2 no esta ejecutandose, por favor ejecutalo',
  'No hay dispositivos USB conectados en esta PC, o los mismos estan apagados',
  'No hay particiones para montar, desmonta alguno por favor',
  'No hay particiones para desmontar, monta alguno por favor',
  'Apagar Dispositivo',
  'Desea apagar el dispositivo',
  'Recuerda que todas sus particiones se desmontarán',
  'Partición montada correctamente',
  'Partición desmontada correctamente',
  'Dispositivo apagado correctamente',
  'Hubo un error al desmontar una partición, por favor verificar',
  'Hubo un error al apagar el dispositivo, por favor verificar',
  'Montar',
  'Desmontar',
  'Apagar',
];

const _dictEng = [
  'You need to be root, please execute with sudo',
  "The udisks command line tool (udisksctl) doesn't exist, please install udisks2",
  'The udisks2 service is not running, please enable the service',
  "There's no USB drives connected in this PC, or the devices are shutdown",
  "There's no partitions to mount, please unmount some partition",
  "There's no partitions to unmount, please mount some partition",
  'Power-off Device',
  'Do you want to power-off the device',
  'Remember that all your partitions will be unmounted',
  'Partition mounted correctly',
  'Partition unmounted correctly',
  'Device power-off correctly',
  'There was an error unmounting a partition, please verify',
  'There was an error powering-off the device, please verify',
  'Mount',
  'Unmount',
  'Power-off',
];

String dict(
  final int index,
  final bool isEng
) => isEng
  ? _dictEsp[index]
  : _dictEng[index];
