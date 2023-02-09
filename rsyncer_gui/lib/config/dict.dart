String dict(int index, bool isEng) {

  const dictEsp = [
    "Origen",
    "Destino",
    "Cancelar",
    "El ejecutable de rsync, no se encuentra en el sistema, por favor instalalo",
    "Salir"
  ];

  const dictEng = [
    "Source",
    "Destination",
    "Cancel",
    "The rsync binary is not available in this system, please install",
    "Exit"
  ];

  return isEng ? dictEsp[index] : dictEng[index];
}