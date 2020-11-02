import 'package:water_app/models/User.dart';
import 'package:water_app/repository/user_repository.dart';

class UserController {
  List<User> list = new List<User>();
  UserRepository repository = new UserRepository();

  Future<void> getAll() async {
    try {
      final allList = await repository.readData();
      list.clear();
      list.addAll(allList);
    } catch(error){
      print("Erro: "+ error.toString());
    }
  }

  Future<void> create(User item) async {
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

  Future<void> updateList(List<User> lista) async {
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