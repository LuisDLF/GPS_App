import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  String account = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue, Colors.white])),
        ),
        SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[this._loginForm(context)],
            ),
          ),
        )
      ]),
    );
  }

  Widget _loginForm(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: this.formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              ClipRRect(borderRadius: BorderRadius.circular(20.0), child: Image(image: AssetImage('assets/imgs/walk_safe.png'))),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Cuenta',
                ),
                onChanged: (val) => this.account = val,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
                onChanged: (val) => this.password = val,
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  child: Text('Entrar'),
                  onPressed: () => this._login(context),
                ),
              ),
//              Container(
//                width: double.infinity,
//                child: RaisedButton(
//                  color: Colors.blueAccent,
//                  child: Text(
//                    'Dispositivo',
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).pushNamed('estatus');
//                  },
//                ),
//              )
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    final resp = await http.post('http://sweetnightmare.xyz/services/Login_Disp.php', body: {'Nombre': this.account, 'Contrasena': this.password});

    try {
      final data = jsonDecode(resp.body);
      Navigator.pushReplacementNamed(context, 'estatus', arguments: data[0]);
    } catch (e) {
      print('Error: ' + e.toString());
      Fluttertoast.showToast(
          msg: "La cuenta o la contraseña es incorrecta",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
