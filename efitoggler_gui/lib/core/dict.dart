const _dictEsp = <String>[
  'Modo Oscuro',
  'Montar',
  'Desmontar',
  'Español',
  'Inglés',
  'La contraseña de sudo es incorrecta',
  'Ingrese su contraseña para continuar',
  'Contraseña',
  'Enviar',
  'Cancelar',
  'Cambiar de modo oscuro',
  'Cambiar de idioma',
  'Salir',
];

const _dictEng = <String>[
  'Dark Mode',
  'Mount',
  'Unmount',
  'Spanish',
  'English',
  'Your sudo password is incorrect',
  'Enter your password to continue',
  'Password',
  'Send',
  'Cancel',
  'Change dark mode',
  'Change language',
  'Exit',
];

String dict(final int index, final bool isEng) =>
    isEng ? _dictEsp[index] : _dictEng[index];
