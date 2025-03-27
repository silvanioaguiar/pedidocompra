import 'package:flutter/material.dart';

class Concorrentes with ChangeNotifier {
  final String codigo;
  final String razaoSocial;
  final String nomeFantasia;
  final String? endereco;
  final String? municipio;
  final String? estado;
  final String? bairro;
  final String? cep;
  final String? ddd;
  final String? telefone;
  final String? contato;
  final String? homePage;

  Concorrentes({
    required this.codigo,
    required this.razaoSocial,
    required this.nomeFantasia,
    this.endereco,
    this.municipio,
    this.estado,
    this.bairro,
    this.cep,
    this.ddd,
    this.telefone,
    this.contato,
    this.homePage,
  });
}
