import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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