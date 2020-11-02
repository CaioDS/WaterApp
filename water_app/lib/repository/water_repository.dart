import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:water_app/models/Water.dart';

class WaterRepository {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<Water>> readData() async {
    try{
      final file = await _localFile;
      String dataJson = await file.readAsString();
      List<Water> data = (json.decode(dataJson) as List).map((i) => Water.FromJson(i)).toList();
      return data;
    } catch (error) {
      return List<Water>();
    }
  }

  Future<bool> saveData(List<Water> list) async {
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

