import 'package:flutter/material.dart';

class FormularioVisita with ChangeNotifier {

  final String codigoVisita;
  final String codigoMedico;
  final String nomeMedico;
  final String codigoLocal;
  final String nomeLocal;
  final DateTime dataVisita;
  final String horaVisita;
  final String avaliacao;
  final String listaHospitais;
  final String clienteDoGrupo;
  final String listaConcorrentes;
  final String especialidade;
  final String proximosPassos;

  FormularioVisita({
    required this.codigoVisita,
    required this.codigoMedico,
    required this.nomeMedico,
    required this.codigoLocal,
    required this.nomeLocal,
    required this.dataVisita,
    required this.horaVisita,
    required this.avaliacao,
    required this.listaHospitais,
    required this.clienteDoGrupo,
    required this.listaConcorrentes,
    required this.especialidade,
    required this.proximosPassos,
  });
}
