import 'package:flutter/material.dart';
import 'package:pedidocompra/models/pedidos.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:pedidocompra/pages/detalhesPedido.dart';
import 'package:pedidocompra/pages/itensPedido.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PedidoGridItem extends StatelessWidget {
  const PedidoGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pedido = Provider.of<Pedidos>(context, listen: false);
    String valor1 = NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
        .format(pedido.valor);

    var empresa = pedido.empresa;
    var logo;

    if (empresa == 'Big Assistencia Tecnica' || empresa == 'Big Locacao') {
      logo = 'assets/images/logo_big.png';
    } else if (empresa == 'Biosat Matriz Fabrica' ||
        empresa == 'Biosat Filial') {
      logo = 'assets/images/logo_biosat2.png';
    } else if (empresa == 'Libertad') {
      logo = 'assets/images/logo_libertad.png';
    } else if (empresa == 'E-med') {
      logo = 'assets/images/logo_emed.png';
    } else if (empresa == 'Brumed') {
      logo = 'assets/images/logo_Brumed.png';
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              //Color.fromARGB(255, 5, 34, 58),
              //Color.fromARGB(255, 150, 35, 27),
              Color.fromARGB(255, 5, 34, 58),
              Color.fromARGB(255, 85, 170, 250),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage(logo),
            alignment: Alignment.topRight,
          ),
        ),
        height: 200,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.empresa,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 102, 245)),
                    ),
                    const SizedBox(),
                    Text(
                      pedido.fornecedor.length > 25
                          ? 'Fornecedor: ${pedido.fornecedor.substring(0, 25)}'
                          : 'Fornecedor: ${pedido.fornecedor}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(),
                    Text(
                      'Pedido: ${pedido.pedido}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(),
                    Text(
                      'Valor Total do Pedido: ${valor1.toString()}',
                      //pedido.valor.toStringAsFixed(2),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Cond. Pgto: ${pedido.condicaoPagamento}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10, width: 100),
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        IconButton(
                          onPressed: () {
                            Provider.of<PedidosLista>(
                              context,
                              listen: false,
                            ).aprovarPedido(context, pedido);
                          },
                          icon: const Icon(Icons.beenhere_sharp,
                              color: Color.fromARGB(255, 34, 185, 39)),
                          iconSize: 30,
                          tooltip: "Aprovar",
                        ),
                        const SizedBox(width: 60),
                        IconButton(
                          onPressed: () {
                            Provider.of<PedidosLista>(
                              context,
                              listen: false,
                            ).reprovarPedido(context, pedido);
                          },
                          icon: const Icon(Icons.cancel,
                              color: Color.fromARGB(255, 155, 27, 27)),
                          iconSize: 30,
                          tooltip: "Reprovar",
                        ),
                        const SizedBox(width: 60),
                        IconButton(
                          onPressed: () {
                              Provider.of<PedidosLista>(
                              context,
                              listen: false,
                            ).loadItensPedidos(context, pedido);

                            // Navigator.of(context).pushNamed(
                            //   AppRoutes.itensPedido
                            // );
                            //ItensPedido(empresa: pedido.pedido,pedido: pedido.empresa,);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ItensPedido(empresa: pedido.empresa, pedido: pedido.pedido,)));

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (ctx) {
                            //     return DetalhesPedido(
                            //         empresa: pedido.empresa, pedido: pedido.pedido,);
                            //   }),
                            // );
                          },
                          icon: const Icon(Icons.list_alt),
                          color: Colors.white,
                          iconSize: 30,
                          tooltip: 'Vizualizar Pedido',
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 60),
                        Text(
                          'Aprovar',
                          style: TextStyle(
                              color: Color.fromARGB(255, 34, 185, 39),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 50),
                        Text(
                          'Reprovar',
                          style: TextStyle(
                              color: Color.fromARGB(255, 155, 21, 21),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 50),
                        Text(
                          'Visualizar',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: GridTile(
//         footer: GridTileBar(
//           backgroundColor: Colors.black87,
//           // leading: Consumer<Pedidos>(
//           //   builder: (ctx, product, _) => IconButton(
//           //     onPressed: () {
//           //       product.toggleFavorite();
//           //     },
//           //     icon: Icon(
//           //         product.isFavorite ? Icons.favorite : Icons.favorite_border),
//           //     color: Theme.of(context).colorScheme.secondary,
//           //   ),
//           // ),
//           title: Text(
//             pedido.pedido,
//             textAlign: TextAlign.center,
//           ),
//           trailing: IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             color: Theme.of(context).colorScheme.secondary,
//             onPressed: () {
//               ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Produto adicionado com sucesso!'),
//                   duration: const Duration(seconds: 2),
//                   action: SnackBarAction(
//                     label: 'DESFAZER',
//                     onPressed: () {
//                       cart.removeSingleItem(product.id);
//                     },
//                   ),
//                 ),
//               );
//               cart.addItem(product);
//             },
//           ),
//         ),
//         child: GestureDetector(
//           child: Image.network(
//             product.imageUrl,
//             fit: BoxFit.cover,
//           ),
//           // onTap: () {
//           //   Navigator.of(context).pushNamed(
//           //     AppRoutes.productDetail,
//           //     arguments: product,
//           //   );
//           // },
//         ),
//       ),
//     );
//   }
// }