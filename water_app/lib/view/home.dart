import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var _personNameController = TextEditingController();
  bool _register = false;
  bool _registerData;
  String _nome;

  void initState() {
    super.initState();
    _verificaCadastro();
  }

  _verificaCadastro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _register = (prefs.getBool('cadastrado') ?? true);
      _registerData = _register == true ? false : true;
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

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('name');
    });
  }

  _setName(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = name;
      prefs.setString('name', name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: _body(),
    );
  }

  _body() {
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
                child: Container(
                  width: 250,
                  height: 100,
                  child: Text('Restam 6 copos de agua'),
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
                child: Text(_registerData == true ? 'Bem Vindo '+'!' : 'Começar',
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
                  return "Digite seu nome";
                else
                  return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Digite seu Nome"),
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
                  _setName(_personNameController.text.toString());
                  //Dashboard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}