import 'dart:convert';

class DispositivoModel {
  String idDispositivo;
  String nombre;
  String contrasena;
  String latitud;
  String longitud;

  DispositivoModel({
    this.idDispositivo,
    this.nombre,
    this.contrasena,
    this.latitud,
    this.longitud,
  });

  DispositivoModel copyWith({
    String idDispositivo,
    String nombre,
    String contrasena,
    String latitud,
    String longitud,
  }) =>
      DispositivoModel(
        idDispositivo: idDispositivo ?? this.idDispositivo,
        nombre: nombre ?? this.nombre,
        contrasena: contrasena ?? this.contrasena,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
      );

  factory DispositivoModel.fromJson(String str) => DispositivoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DispositivoModel.fromMap(Map<String, dynamic> json) => DispositivoModel(
    idDispositivo: json["Id_Dispositivo"] == null ? null : json["Id_Dispositivo"],
    nombre: json["Nombre"] == null ? null : json["Nombre"],
    contrasena: json["Contrasena"] == null ? null : json["Contrasena"],
    latitud: json["Latitud"] == null ? null : json["Latitud"],
    longitud: json["Longitud"] == null ? null : json["Longitud"],
  );

  Map<String, dynamic> toMap() => {
    "Id_Dispositivo": idDispositivo == null ? null : idDispositivo,
    "Nombre": nombre == null ? null : nombre,
    "Contrasena": contrasena == null ? null : contrasena,
    "Latitud": latitud == null ? null : latitud,
    "Longitud": longitud == null ? null : longitud,
  };
}