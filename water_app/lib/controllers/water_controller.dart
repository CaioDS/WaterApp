import 'package:water_app/models/Water.dart';
import 'package:water_app/repository/water_repository.dart';

class WaterController {
  List<Water> list = new List<Water>();
  WaterRepository repository = new WaterRepository();

  Future<void> getAll() async {
    try {
      final allList = await repository.readData();
      list.clear();
      list.addAll(allList);
    } catch(error){
      print("Erro: "+ error.toString());
    }
  }

  Future<void> create(Water item) async {
    try {
      list.add(item);
      await update();
    } catch(error){
      print("Error " + error.toString());
    }
  }

  void update() async{
    await repository.saveData(list);
    await getAll();
  }

  Future<void> updateList(List<Water> lista) async {
    await repository.saveData(lista);
    await getAll();
  }

  Future<void> delete(int id) async {
    try{
      list.removeAt(id);
      await update();
    } catch(error) {
      print("Error " + error.toString());
    }
  }

}