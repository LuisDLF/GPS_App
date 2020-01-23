import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// https://sweetnightmare.xyz/services/Gps_Upload.php
// https://sweetnightmare.xyz/services/Gps_read.php

class EstatusPage extends StatefulWidget {
  @override
  _EstatusPageState createState() => _EstatusPageState();
}

class _EstatusPageState extends State<EstatusPage> {
  Position position;
  String lat = 'desconocido';
  String lng = 'desconocido';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estatus del servicio GPS'),
      ),
      body: Container(
        child: Center(
          child: Column(
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
    print('getPosition');
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    http.post('https://sweetnightmare.xyz/services/Gps_Upload.php', body: {
      'Id_Disp': '1',
      'Lon': position.longitude.toString(),
      'Lat': position.latitude.toString()
    });

    setState(() {
      this.lng = position.longitude.toString();
      this.lat = position.latitude.toString();
    });
  }
}
