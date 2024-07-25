import 'package:flutter/material.dart';
import 'package:pedidocompra/components/faturamentoComponents/fatNotasDoPeriodoItem.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_notasDoPeriodoLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_notasDoPeriodo.dart';
import 'package:provider/provider.dart';

class FatNotasDoPeriodoGrid extends StatelessWidget {
  const FatNotasDoPeriodoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatNotasDoPeriodo = Provider.of<FatNotasDoPeriodoLista>(context); 
    final List<FaturamentoNotasDoPeriodo> loadedNotasDoPeriodo =
        providerFatNotasDoPeriodo.notaFiscal;

    return ListView.builder(      
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedNotasDoPeriodo.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(        
        value: loadedNotasDoPeriodo[i],
        child: const FatNotasDoPeriodoItem(),
      ),
    );
    //);
  }
}
