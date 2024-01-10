import 'package:flutter/material.dart';


class ItensPedidos with ChangeNotifier {
  final String empresa;
  final String pedido;
  final String fornecedor;
  final double valor;
  final String condicaoPagamento;
  final String codProduto;
  final String nomeProduto;
  final double quantidade;
  final String unidadeMedida;
  final double precoUnitario;
  final double precoTotal;
  final String sc;
  final String solicitante;
  final String dataSC;
  final String aprovadorDaSC;
  final String dataAprovacaoSC;
  final String comprador;
  final String status;

  
  ItensPedidos({
    required this.empresa,
    required this.pedido,
    required this.fornecedor,
    required this.valor,
    required this.condicaoPagamento,
    required this.codProduto,
    required this.nomeProduto,
    required this.quantidade,
    required this.unidadeMedida,
    required this.precoUnitario,
    required this.precoTotal,
    required this.sc,
    required this.solicitante,
    required this.dataSC,
    required this.aprovadorDaSC,
    required this.dataAprovacaoSC,
    required this.comprador,
    required this.status
   
  });

 
}