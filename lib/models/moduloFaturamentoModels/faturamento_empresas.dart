import 'package:flutter/material.dart';

class FaturamentoEmpresas with ChangeNotifier {
  final String empresa; 
  //final double valor;
  final String valorReal; 
  //final String valorTotal;

  FaturamentoEmpresas({
    required this.empresa,   
    //required this.valor,
    required this.valorReal,
    //required this.valorTotal,
    
  });
}
