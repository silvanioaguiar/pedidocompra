import 'package:flutter/material.dart';

class FaturamentoEmpresas with ChangeNotifier {
  final String empresa;   
  final String valorReal; 
  final String valorTotal;
  final String valorDia;
  

  FaturamentoEmpresas({
    required this.empresa,    
    required this.valorReal,
    required this.valorTotal,
    required this.valorDia,
    
    
  });
}
