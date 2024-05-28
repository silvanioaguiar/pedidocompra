import 'package:flutter/material.dart';
import 'package:pedidocompra/components/faturamentoComponents/fatConvenioItem.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_convenioLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_convenio.dart';
import 'package:provider/provider.dart';

class FatConvenioGrid extends StatelessWidget {
  const FatConvenioGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatConvenio = Provider.of<FatConvenioLista>(context);
    final List<FaturamentoConvenio> loadedConvenios =
        providerFatConvenio.convenios;

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedConvenios.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedConvenios[i],
        child: const FatConvenioItem(),
      ),
    );
    //);
  }
}
