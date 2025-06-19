import 'package:flutter/material.dart';

class Visitas with ChangeNotifier {
  String codigo;
  String status;
  String codigoRepresentante;
  String nomeRepresentante;
  String codigoMedico;
  String nomeMedico;
  String codigoLocalDeEntrega;
  String local;
  DateTime dataPrevista;
  DateTime? dataRealizada;
  String horaPrevista;
  String? horaRealizada;
  String nomeUsuario;
  String? codFormulario;
  String objetivo;
  String? cancelarMotivo;

  Visitas({
    required this.codigo,
    required this.status,
    required this.codigoRepresentante,
    required this.nomeRepresentante,
    required this.codigoMedico,
    required this.nomeMedico,
    required this.codigoLocalDeEntrega,
    required this.local,
    required this.dataPrevista,
    this.dataRealizada,
    required this.horaPrevista,
    this.horaRealizada,
    required this.nomeUsuario,
    this.codFormulario,
    required this.objetivo,
    this.cancelarMotivo,
  });
}
