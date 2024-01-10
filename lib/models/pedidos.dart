import 'package:flutter/material.dart';


class Pedidos with ChangeNotifier {
  final String empresa;
  final String pedido;
  final String fornecedor;
  final double valor;
  final String condicaoPagamento;
  final String status;
  // final String sc;
  // final String solicitante;
  // final String dataSC;
  // final String aprovadorDaSC;
  // final String dataAprovacaoSC;
  final String comprador;
  final String aprovadorPedido;
  
  Pedidos({
    required this.empresa,
    required this.pedido,
    required this.fornecedor,
    required this.valor,
    required this.condicaoPagamento,
    required this.status,
    // required this.sc,
    // required this.solicitante,
    // required this.dataSC,
    // required this.aprovadorDaSC,
    // required this.dataAprovacaoSC,
    required this.comprador,
    required this.aprovadorPedido,
   
  });

 
}