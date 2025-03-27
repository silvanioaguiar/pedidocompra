import 'package:flutter/material.dart';
import 'package:pedidocompra/components/faturamentoComponents/fatNotasDoDiaItem.dart';
import 'package:pedidocompra/providers/faturamento/fat_notasDoDiaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_notasDoDia.dart';
import 'package:provider/provider.dart';

class FatNotasDoDiaGrid extends StatelessWidget {
  const FatNotasDoDiaGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatNotasDoDia = Provider.of<FatNotasDoDiaLista>(context); 
    final List<FaturamentoNotasDoDia> loadedNotasDoDia =
        providerFatNotasDoDia.notaFiscal;

    return ListView.builder(      
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedNotasDoDia.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(        
        value: loadedNotasDoDia[i],
        child: const FatNotasDoDiaItem(),
      ),
    );
    //);
  }
}
