import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:pedidocompra/providers/faturamento/fat_empresaLista.dart';
import 'package:provider/provider.dart';

class FatEmpresasTotal extends StatelessWidget {
  const FatEmpresasTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatEmpresasTotal = Provider.of<FatEmpresaLista>(context);
    final List<FaturamentoEmpresas> loadedEmpresas =
        providerFatEmpresasTotal.empresas;
    double vlTotal =
        double.parse(loadedEmpresas[loadedEmpresas.length - 1].valorTotal);
    String vlTotalFormatado =
        NumberFormat.currency(locale: "pt_BR", symbol: "R\$").format(vlTotal);
    double vlTotalDia =
        double.parse(loadedEmpresas[loadedEmpresas.length - 1].valorTotalDia);
    String vlTotalDiaFormatado =
        NumberFormat.currency(locale: "pt_BR", symbol: "R\$")
            .format(vlTotalDia);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          height: 40,
          //color: const Color.fromARGB(255, 138, 201, 253),
          child: Text(
            'Total Faturado: $vlTotalFormatado',
            style: TextStyle(
              color:Theme.of(context).secondaryHeaderColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 161, 18, 8),
            borderRadius: BorderRadius.circular(10)
          ),
          height: 40,
          //color: Color.fromARGB(255, 255, 251, 41),
          child: Text(
            'Total do Dia: $vlTotalDiaFormatado',
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
