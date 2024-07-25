import 'package:flutter/material.dart';

class FaturamentoNotasDoPeriodo with ChangeNotifier {
  final String empresa;
  final String notaFiscal;
  final String serieNotaFiscal;
  final String emissaoNotaFiscal;
  final String valorNota;
  final String razaoSocial;
  final String cliente;
  final String condicaoPagamento;


  FaturamentoNotasDoPeriodo({
    required this.empresa,
    required this.notaFiscal,
    required this.serieNotaFiscal,
    required this.emissaoNotaFiscal,
    required this.valorNota,
    required this.razaoSocial,
    required this.cliente,
    required this.condicaoPagamento,    
    
  });
}


