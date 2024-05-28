import 'package:flutter/material.dart';
import 'package:pedidocompra/components/comprasComponents/pedidoGridItem.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidosLista.dart';
import 'package:provider/provider.dart';

class PedidoGrid extends StatelessWidget {
  const PedidoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PedidosLista>(context);
    final List<Pedidos> loadedPedidos = provider.pedidos;

    return GridView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedPedidos.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedPedidos[i],
        child: const PedidoGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3.5 / 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
    );
  }
}
