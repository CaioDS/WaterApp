import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({ Key key }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {

  void initState() {
    super.initState();
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

  _body() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Seu Peso:  ' + '70' + ' KG',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ],
        ),
      ],
    );
  }
}