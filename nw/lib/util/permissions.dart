// import 'package:simple_permissions/simple_permissions.dart';
import 'package:permission/permission.dart';

/* Future<bool> initPermissions() async {
  final permissoes = [
    Permission.WriteExternalStorage,
    // Permission.ReadExternalStorage,
    Permission.RecordAudio,
    Permission.ReadContacts,
    Permission.WriteContacts,
  ];
  bool chk = false;
  try {

    // checa se as permissões de acesso (read_contacts, ...)já estão concedidas
    // senão, pergunta ao usuário se ele as permite
    for (int i = 0; i < permissoes.length; i++) {
      chk = await SimplePermissions.checkPermission(permissoes[i]);
      if (!chk) {
        await SimplePermissions.requestPermission(permissoes[i]);
      }
    }
    return true;
    
  } on Error {
    print("\n          Erro ao requisitar permissões.            \n");
    return false;
  }
} */

void getPermissions() async {
  final result = await Permission.requestPermissions([
    PermissionName.Contacts,
    PermissionName.Microphone,
    PermissionName.Storage
  ]);
  for(var permission in result) 
    print('${permission.permissionName}: ${permission.permissionStatus}'); 
}


