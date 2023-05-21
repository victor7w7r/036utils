const _dictEsp = [
  'Origen',
  'Destino',
  'Cancelar',
  'El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo',
  'Salir'
];

const _dictEng = [
  'Source',
  'Destination',
  'Cancel',
  'The rsync binary is not available in this system, please install',
  'Exit'
];

String dict(
  final int index,
  final bool isEng
) => isEng
  ? _dictEsp[index] : _dictEng[index];
