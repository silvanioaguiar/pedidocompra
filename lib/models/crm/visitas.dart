import 'package:flutter/material.dart';


class Visitas with ChangeNotifier {
  final String codigo;
  final String status;
  final String codigoRepresentante; 
  final String nomeRepresentante;
  final String codigoMedico;
  final String nomeMedico;
  final String codigoLocalDeEntrega;
  final String local;
  final DateTime dataPrevista;
  final DateTime? dataRealizada;
  final String  horaPrevista;
  final String?  horaRealizada;
  final String nomeUsuario;
  
  
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
  
   
  });

 
}