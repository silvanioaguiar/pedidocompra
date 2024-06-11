import 'package:flutter/material.dart';

class FaturamentoLocalDeEntrega with ChangeNotifier {
  final String empresa;
  final String localDeEntrega;
  //final double valor;
  final String valorReal;
  final int    ranking;   

  FaturamentoLocalDeEntrega({
    required this.empresa,
    required this.localDeEntrega,
    //required this.valor,
    required this.valorReal,
    required this.ranking,
  });
}
