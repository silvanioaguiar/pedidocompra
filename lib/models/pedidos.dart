import 'package:flutter/material.dart';


class Pedidos with ChangeNotifier {
  final String empresa;
  final String pedido;
  final String fornecedor;
  final double valor;
  final String condicaoPagamento;
  
  Pedidos({
    required this.empresa,
    required this.pedido,
    required this.fornecedor,
    required this.valor,
    required this.condicaoPagamento,
   
  });

 
}