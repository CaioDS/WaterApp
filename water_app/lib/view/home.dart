import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_app/models/User.dart';
import 'package:water_app/models/Water.dart';
import 'package:water_app/controllers/user_controller.dart';
import 'package:water_app/controllers/water_controller.dart';

import 'package:water_app/view/dashboard.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  var _userController = UserController();
  var _waterController = WaterController();
  var _user = List<User>();
  var _water = List<Water>();
  var _personNameController = TextEditingController();
  bool _register = false;
  bool _registerData;
  var _peso;
  double _pesoData;

  void initState() {
    super.initState();
    _verificaCadastro();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userController.getAll().then((data) {
        setState(() {
          _user = _userController.list;
        });
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waterController.getAll().then((data) {
        setState(() {
          _water = _waterController.list;
        });
      });
    });
  }

  _verificaCadastro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _register = (prefs.getBool('cadastrado') ?? true);
      _registerData = _register == true ? true : false;
    });
  }

  _setCadastro(cadastrado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _register = cadastrado;
      _registerData = _register == true ? true : false;
      print(_registerData);
      prefs.setBool('cadastrado', cadastrado);
    });
  }

  getPeso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _peso = prefs.getDouble('peso') ?? _pesoData;
      _pesoData = _peso == _pesoData ? _peso : _peso;
    });
  }

  _setPeso(peso) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _peso = peso;
      prefs.setDouble('peso', peso);
    });
    print(peso);
  }

  int _coposRestantes() {
    int copos = 0;
    for(int i=0; i < _waterController.list.length; i++ ) {
      if(_waterController.list[i].Active == false)
        copos= copos+1;
    }

    return copos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: _body(),
    );
  }

  _body() {
    int copos_restantes = _coposRestantes();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 375,
              margin: EdgeInsets.only(top: 150, bottom: 30),
              child: Image.asset('imagens/image_home.png'),
            ),
          ],
        ),
        if(_registerData == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(bottom: 40),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    width: 250,
                    height: 60,
                    child: Text('Restam '+copos_restantes.toString()+' copos de água!!', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 200,
              height: 50,
              child: FloatingActionButton(
                child: Text(_registerData == true ? 'Bem Vindo !' : 'Começar',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                onPressed: _registerData == false ? _cadastrarUsuario : () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard())),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _cadastrarUsuario() {
    print("entrou");
    _showDialog(context);
  }

  _showDialog(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _personNameController,
              validator: (s) {
                if(s.isEmpty)
                  return "Digite seu Peso";
                else
                  return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Digite seu Peso"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Avançar",
                style: TextStyle(color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if(_formKey.currentState.validate())
                  _setCadastro(true);
                  _setPeso(_personNameController.text);
                  _userController.create(User(Peso: double.parse(_personNameController.text)));
                  _calcularQuantidadeAgua(double.parse(_personNameController.text));
                  //Dashboard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _calcularQuantidadeAgua(double peso) {
    double copos = (peso * 35)/200;
    for(int i = 0; i < copos; i++)
      _waterController.create(Water(Id: i, Active: false));
  }

}