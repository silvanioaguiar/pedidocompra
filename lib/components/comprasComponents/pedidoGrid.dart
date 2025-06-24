import 'package:flutter/material.dart';
import 'package:pedidocompra/components/comprasComponents/pedidoGridItem.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/providers/compras/pedidosLista.dart';
import 'package:provider/provider.dart';

class PedidoGrid extends StatelessWidget {
  const PedidoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PedidosLista>(context);
    final List<Pedidos> loadedPedidos = provider.pedidos;
    var size = MediaQuery.of(context).size;

    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600 && size.height >= 600) {
      sizeCrossAxisCount = 3;
      sizeAspectRatio = 1.6;
    } else {
      sizeCrossAxisCount = 1;
      sizeAspectRatio = 2.6 / 2.3;
    }

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedPedidos.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedPedidos[i],
        child: const PedidoGridItem(),
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
