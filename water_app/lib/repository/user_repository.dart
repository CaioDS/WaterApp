import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:water_app/models/User.dart';

class UserRepository {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/datas.json');
  }

  Future<List<User>> readData() async {
    try{
      final file = await _localFile;
      String dataJson = await file.readAsString();
      List<User> data = (json.decode(dataJson) as List).map((i) => User.FromJson(i)).toList();
      return data;
    } catch (error) {
      return List<User>();
    }
  }

  Future<bool> saveData(List<User> list) async {
    try {
      final file = await _localFile;
      final String data = json.encode(list);
      file.writeAsString(data);
      return true;

    } catch(error) {
      return false;
    }
  }

}

