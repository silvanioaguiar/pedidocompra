import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_empresaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:provider/provider.dart';

class FatEmpresasTotal extends StatelessWidget {
  const FatEmpresasTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatEmpresasTotal = Provider.of<FatEmpresaLista>(context);
    final List<FaturamentoEmpresas> loadedEmpresas =
        providerFatEmpresasTotal.empresas;
    double vlTotal = double.parse(loadedEmpresas[loadedEmpresas.length - 1].valorTotal);  
    String vlTotalFormatado = NumberFormat.currency(locale: "pt_BR", symbol: "R\$").format(vlTotal);
    

    return Container(
      color: const Color.fromARGB(255, 138, 201, 253),
      child: Text(
        'Total Faturado: $vlTotalFormatado',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
