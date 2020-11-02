import 'package:flutter/material.dart';
import 'package:water_app/controllers/user_controller.dart';
import 'package:water_app/models/Water.dart';
import 'package:water_app/models/User.dart';
import 'package:water_app/controllers/water_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({ Key key }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  var _copos = List<Water>();
  var _user = List<User>();
  var _waterController = WaterController();
  var _userController = UserController();
  var _peso;
  double _pesoData;

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waterController.getAll().then((data) {
        setState(() {
          _copos = _waterController.list;
        });
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userController.getAll().then((data) {
        setState(() {
          _user = _userController.list;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Water App'),
      ),
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  getPeso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _peso = prefs.getDouble('peso') ?? _pesoData;
      _pesoData = _peso == true ? _peso : _peso;
    });
    print(_pesoData);
    return _pesoData;
  }

  _body() {
    print(_pesoData);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Seu Peso:  ' + _user[0].Peso.toString() + ' KG',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(int i=0; i < (_copos.length); i++)
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: FlatButton(
                            onPressed: () => {
                              if(_copos[i].Active == false)
                                _copos[i].Active = true
                              else
                                _copos[i].Active = false,
                              setState(() {
                                _waterController.updateList(_copos);
                              })
                            },
                            child: _copos[i].Active == false
                                ? Image.asset('imagens/triste.png')
                                : Image.asset('imagens/feliz.png'),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

            ],
          ),
        ),
      ],
    );
  }
}