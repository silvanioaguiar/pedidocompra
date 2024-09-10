import 'package:flutter/material.dart';
import 'package:pedidocompra/components/comprasComponents/itensPedidoGridItem.dart';
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidosLista.dart';
import 'package:provider/provider.dart';



class ItensPedidoGrid extends StatelessWidget {
  

  const ItensPedidoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final providerItens = Provider.of<ItensPedidosLista>(context);
    final providerItens = Provider.of<PedidosLista>(context);
    final List<ItensPedidos> loadedItensPedidos = providerItens.itensDoPedido;
    final List<dynamic> loadedItensPedidos2 = providerItens.data2;
    
    return GridView.builder(         
      itemCount: loadedItensPedidos.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedItensPedidos[i],
        child:  const ItensPedidoGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(        
        crossAxisCount: 1,
        childAspectRatio: 10,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
    );
    // return Row(
    //   children: [
    //     build(context) => ChangeNotifierProvider.value(
    //      value: loadedItensPedidos[i],)
    //   ],
    // );
  }
}