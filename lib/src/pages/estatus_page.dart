import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_app/src/models/dispositivo_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// https://sweetnightmare.xyz/services/Gps_Upload.php
// https://sweetnightmare.xyz/services/Gps_read.php

class EstatusPage extends StatefulWidget {
  @override
  _EstatusPageState createState() => _EstatusPageState();
}

class _EstatusPageState extends State<EstatusPage> {
  DispositivoModel model;

  String lat = 'desconocido';
  String lng = 'desconocido';

  @override
  Widget build(BuildContext context) {
    this.model = DispositivoModel.fromMap(ModalRoute.of(context).settings.arguments);

    this.lat = this.model.latitud;
    this.lng = this.model.longitud;

    return Scaffold(
      appBar: AppBar(
        title: Text('Estatus del servicio GPS'),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Lat: ' + lat),
              Text('Lng: ' + lng),
              RaisedButton(
                child: Text('Optener cordenadas'),
                onPressed: () => this.getPosition(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    http.post('https://sweetnightmare.xyz/services/Gps_Upload.php',
        body: {'Id_Disp': this.model.idDispositivo, 'Lon': position.longitude.toString(), 'Lat': position.latitude.toString()});

    setState(() {
      this.lng = position.longitude.toString();
      this.lat = position.latitude.toString();
    });

    Fluttertoast.showToast(
        msg: "Se actualizo las cordenadas (Lat: ${position.latitude.toString()}, Lng: ${position.longitude.toString()})",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}
