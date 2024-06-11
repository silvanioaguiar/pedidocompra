import 'package:flutter/material.dart';

class FaturamentoEmpresas with ChangeNotifier {
  final String empresa;   
  final String valorReal; 
  final String valorTotal;
  final String valorTotalDia;
  final String valorDia;
  final String dateIni;
  final String dateFim;
  

  FaturamentoEmpresas({
    required this.empresa,    
    required this.valorReal,
    required this.valorTotal,
    required this.valorTotalDia,
    required this.valorDia,
    required this.dateIni,
    required this.dateFim,
    
    
  });
}
