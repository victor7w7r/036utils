// ignore_for_file: no_adjacent_strings_in_list, lines_longer_than_80_chars
import 'package:zerothreesix_dart/zerothreesix_dart.dart'
    show setDictEng, setDictEsp;

void initLang() {
  setDictEsp([
    'Este sistema no es GNU/Linux, saliendo',
    'Necesitas ser superusuario, por favor ejecuta con sudo',
    'El ejecutable e4defrag no está presente en tu sistema, por favor instalalo',
    'fsck.ext4 no está presente en tu sistema, por favor instalalo',
    'Todo ok!',
    'No hay particiones ext4 disponibles en el sistema, solo funciona con dispositivos USB',
    'Todas las particiones ext4 estan montadas en el sistema, '
        'por favor desmontar la particion deseada para optimizar',
    '=============== VERIFICAR ERRORES EN EL SISTEMA DE ARCHIVOS =============== \n',
    '=============== FALLA =============== \n',
    '=============== LISTO =============== \n',
    '=============== OPTIMIZAR EL SISTEMA DE ARCHIVOS =============== \n',
    '=============== DESFRAGMENTAR EL SISTEMA DE ARCHIVOS, ESPERE POR FAVOR =============== \n',
    '=============== VERIFICAR POR ULTIMA VEZ EL SISTEMA DE ARCHIVOS =============== \n',
    'Numero: ',
    'Por favor selecciona una partition\n',
    'Optimizar',
    'Salir al shell',
    'Presione Enter para continuar...',
  ]);
  setDictEng([
    'Your Operating System is not GNU/Linux, exiting',
    'You need to be root, please execute with sudo',
    'e4defrag binary is not present in this system, please install',
    'fsck.ext4 is not present in this system, please install',
    'All dependencies is ok!',
    "There's not ext4 partitions available, only works with USB devices",
    'All the ext4 partitions are mounted in your system, please unmount '
        'the desired partition to optimize',
    '=============== VERIFY FILESYSTEM ERRORS =============== \n',
    '=============== FAILURE =============== \n',
    '=============== OK =============== \n',
    '=============== OPTIMIZE FILESYSTEM =============== \n',
    '=============== DEFRAG FILESYSTEM, PLEASE WAIT =============== \n',
    '=============== LAST VERIFY FILESYSTEM =============== \n',
    'Number: ',
    'Please select a partition\n',
    'Optimize',
    'Exit to the shell',
    'Press Enter to continue...',
  ]);
}
