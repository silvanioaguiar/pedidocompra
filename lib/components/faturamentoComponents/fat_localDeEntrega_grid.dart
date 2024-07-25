import 'package:flutter/material.dart';
import 'package:pedidocompra/components/faturamentoComponents/fatLocalDeEntregaItem.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_localDeEntregaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_localDeEntrega.dart';
import 'package:provider/provider.dart';

class FatLocalDeEntregaGrid extends StatelessWidget {
  const FatLocalDeEntregaGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatLocalDeEntrega =
        Provider.of<FatLocalDeEntregaLista>(context);
    final List<FaturamentoLocalDeEntrega> loadedLocalDeEntrega =
        providerFatLocalDeEntrega.localDeEntrega;
    var size = MediaQuery.of(context).size;

    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600 && size.height >= 600) {
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 5.0;
    } else {
      sizeCrossAxisCount = 1;
      sizeAspectRatio = 5.0;
    }

    return GridView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedLocalDeEntrega.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedLocalDeEntrega[i],
        child: const FatLocalDeEntregaItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sizeCrossAxisCount,
        childAspectRatio: sizeAspectRatio,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
    );
  }
}
