import 'package:simple_permissions/simple_permissions.dart';

Future<bool> initPermissions() async {
  final permissoes = [
    Permission.ReadContacts,
    Permission.WriteContacts,
    Permission.RecordAudio
  ];
  bool chk = false;
  try {

    // checa se as permissões de acesso (read_contacts, ...)já estão concedidas
    // senão, pergunta ao usuário se ele as permite
    for (int i = 0; i < permissoes.length; i++) {
      chk = await checkPermission(permissoes[i]);
      if (!chk) {
        await requestPermission(permissoes[i]);
      }
    }

    return true;
  } on Error {
    print("\n          Erro ao requisitar permissões.            \n");
    return false;
  }
}

Future requestPermission(Permission permission) async {
  var res = await SimplePermissions.requestPermission(permission);
  print("permission READ request result is " + res.toString());
  //return res;
}

Future<bool> checkPermission(Permission permission) async {
  bool res = await SimplePermissions.checkPermission(permission);
  print("permission is " + res.toString());
  return res;
}

// getPermissionStatus() async {
//   final res = await SimplePermissions.getPermissionStatus(permission);
//   print("permission status is " + res.toString());
// }
