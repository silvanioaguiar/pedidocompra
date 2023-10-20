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
   
  });

 
}