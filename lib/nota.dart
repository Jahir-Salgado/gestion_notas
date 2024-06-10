import 'package:cloud_firestore/cloud_firestore.dart';

class Nota {
  String id;
  String descripcion;
  DateTime fecha;
  String estado;
  bool importante;

  Nota({required this.id, required this.descripcion, required this.fecha, required this.estado, required this.importante});

  factory Nota.fromMap(Map<String, dynamic> data, String documentId) {
    return Nota(
      id: documentId,
      descripcion: data['descripcion'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      estado: data['estado'],
      importante: data['importante'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'fecha': fecha,
      'estado': estado,
      'importante': importante,
    };
  }
}