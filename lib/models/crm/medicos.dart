import 'package:flutter/material.dart';

class Medicos with ChangeNotifier {
  final String codigo;
  String nomeMedico;
  String representante;
  String? crm;
  String? especialidade;
  String? localDeVisita;
  String? enderecoVisita;
  String? bairro;
  String? cep;
  String? municipio;
  String? estado;
  String? ddd;
  String? email;
  String? contato;
  String? telefone;
  String? tipoLocal;

  

  Medicos({
    required this.codigo,
    required this.nomeMedico,
    required this.representante,
    this.crm,
    this.especialidade,
    this.localDeVisita,
    this.enderecoVisita,
    this.bairro,
    this.cep,
    this.municipio,
    this.estado,
    this.ddd,
    this.email,
    this.contato,
    this.telefone,
    this.tipoLocal,

  });
}
