import 'package:flutter/material.dart';

class Contatos with ChangeNotifier {
  final String codigo;
  final String nome;  
  final String email;
  final String ddd;
  final String celular;
  

  Contatos({
    required this.codigo,
    required this.nome,
    required this.email,
    required this.ddd,
    required this.celular, 
  });
}
