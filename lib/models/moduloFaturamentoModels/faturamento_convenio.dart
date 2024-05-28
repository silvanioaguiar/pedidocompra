import 'package:flutter/material.dart';

class FaturamentoConvenio with ChangeNotifier {
  final String empresa;
  final String convenio;
  //final double valor;
  final String valorReal;
  final int    ranking;   

  FaturamentoConvenio({
    required this.empresa,
    required this.convenio,
    //required this.valor,
    required this.valorReal,
    required this.ranking,
  });
}
