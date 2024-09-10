import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidosLista.dart';
import 'package:pedidocompra/pages/moduloCompras/detalhesPedido.dart';
import 'package:pedidocompra/pages/moduloCompras/itensPedido.dart';
import 'package:pedidocompra/pages/moduloCompras/pedidosPendentes.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PedidoGridItem extends StatelessWidget {
  const PedidoGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final pedido = Provider.of<Pedidos>(context, listen: false);
    final pedido = Provider.of<Pedidos>(context);
    //String valor1 = NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
    //    .format(pedido.valor);

    var empresa = pedido.empresa;
    var logo;
    var status = pedido.status;
    var color1Card;
    var color2Card;

    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;
    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600) {
      widthScreen = 400;
      heightScreen = 300;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.8;
      heightScreen = size.height * 0.6;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

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

    if (status == "Aguardando Aprovação") {
      color1Card = const Color.fromARGB(255, 5, 34, 58);
      color2Card = const Color.fromARGB(255, 85, 170, 250);
    } else if (status == "Pendente de Entrega") {
      color1Card = const Color.fromARGB(255, 58, 5, 5);
      color2Card = const Color.fromARGB(255, 162, 230, 255);
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              //Color.fromARGB(255, 5, 34, 58),
              //Color.fromARGB(255, 150, 35, 27),
              //Color.fromARGB(255, 5, 34, 58),
              //Color.fromARGB(255, 85, 170, 250),
              color1Card,
              color2Card,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
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
              child: SizedBox(
                width: 320,
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
                      'Valor Total do Pedido: ${pedido.valor.toString()}',
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
                    if (status == "Pendente de Entrega")
                      Text(
                        'Comprador: ${pedido.comprador}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (status == "Pendente de Entrega")
                      Text(
                        'Pedido Aprovado por: ${pedido.aprovadorPedido}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 10, width: 100),
                    if (status == "Aguardando Aprovação")
                      SingleChildScrollView(
                        child: Row(
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
                            const SizedBox(width: 40),
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
                            const SizedBox(width: 40),
                            IconButton(
                              onPressed: () {
                                Provider.of<PedidosLista>(
                                  context,
                                  listen: false,
                                ).loadItensPedidos(context, pedido);
                              },
                              icon: const Icon(Icons.list_alt),
                              color: Colors.white,
                              iconSize: 30,
                              tooltip: 'Vizualizar Pedido',
                            ),
                          ],
                        ),
                      ),
                    if (status == "Pendente de Entrega")
                      Row(
                        children: [
                          const SizedBox(width: 60),
                          IconButton(
                            onPressed: () {
                              Provider.of<PedidosLista>(
                                context,
                                listen: false,
                              ).loadItensPendentesEntrega(context, pedido);
                            },
                            icon: const Icon(Icons.list_alt),
                            color: Colors.white,
                            iconSize: 30,
                            tooltip: 'Vizualizar Pedido',
                          ),
                          const SizedBox(width: 80),
                          IconButton(
                            onPressed: () {
                              Provider.of<PedidosLista>(
                                context,
                                listen: false,
                              ).estornarLiberacao(context, pedido);
                            },
                            icon: const Icon(Icons.cancel,
                                color: Color.fromARGB(255, 155, 27, 27)),
                            iconSize: 30,
                            tooltip: "Estornar",
                          ),
                        ],
                      ),
                    if (status == "Aguardando Aprovação")
                      const Row(
                        children: [
                          SizedBox(width: 50),
                          Text(
                            'Aprovar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 34, 185, 39),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 35),
                          Text(
                            'Reprovar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 155, 21, 21),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Visualizar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    if (status == "Pendente de Entrega")
                      const Row(
                        children: [
                          SizedBox(width: 50),
                          Text(
                            'Vizualizar',
                            style: TextStyle(
                                color: Color.fromARGB(255, 34, 185, 39),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 35),
                          Text(
                            'Estornar Liberação',
                            style: TextStyle(
                                color: Color.fromARGB(255, 155, 21, 21),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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