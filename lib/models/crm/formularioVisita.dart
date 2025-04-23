import 'package:flutter/material.dart';

class FormularioVisita with ChangeNotifier {

  String codigoFormulario;
  String codigoVisita;
  String codigoMedico;
  String nomeMedico;
  String codigoLocal;
  String nomeLocal;
  DateTime dataVisita;
  String horaVisita;
  String avaliacao;
  String listaHospitais;
  String clienteDoGrupo;
  String listaConcorrentes;
  String especialidade;
  String proximosPassos;

  FormularioVisita({
    required this.codigoFormulario,
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
