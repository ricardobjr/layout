import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("\n      ***********       LOCALPATH: ${directory.path}    ************           \n");
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/credentials.txt');
  }

  // excluir se der erro
  Future<File> get _openChatListFile async {
    final path = await _localPath;
    return File('$path/open_chat_list.txt');

  }

  Future<File> writeData(String username, String password) async {
    final file = await _localFile;
    return file.writeAsString('$username~$password');
  }

  Future<String> readData() async {
    try {
      var file = await _localFile;
      if(!await file.exists()) {
        print("não existe!!!!!!!");
        file.create();
      }
      if(await file.exists() && file.readAsStringSync().isEmpty) {
        file.delete();
        file = await _localFile..create();
      }
      String contents = await file.readAsString();
      print("Dados do file: $contents");
      return contents;
    }
    catch(e) {
      print(" ###############   $e  3#################            ");
      return "error";
    }
  }


  // tudo abaixo: excluir se der erro

  Future<File> writeChatTileList(String name) async {
    final file = await _openChatListFile;
    return file.writeAsString('$name~', mode: FileMode.append);
  }

  Future<String> readChatList() async {
    try {
      var file = await _openChatListFile;
      String contents = await file.readAsString();
      print("Dados do file '${file.path}': $contents");
      return contents;
    }
    catch(e) {
      print("ERROR ON READING CHATLIST FILE");
      return "Teste";
    }
  }

}