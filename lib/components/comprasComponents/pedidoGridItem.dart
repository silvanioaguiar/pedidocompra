import 'package:flutter/material.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/providers/compras/pedidosLista.dart';
import 'package:provider/provider.dart';

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
    var colorBorder;

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
      widthScreen = size.width * 0.9;
      heightScreen = size.height * 0.6;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    if (empresa == 'Big Assistencia Tecnica' || empresa == 'Big Locacao') {
      logo = 'assets/images/logos/Icone_Big_03.png';
    } else if (empresa == 'Biosat Matriz Fabrica' ||
        empresa == 'Biosat Filial') {
      logo = 'assets/images/logos/Icone_Biosat_03.png';
    } else if (empresa == 'Libertad') {
      logo = 'assets/images/logos/Icone_Liberttad_03.png';
    } else if (empresa == 'E-med') {
      logo = 'assets/images/logos/Icone_EMed_03.png';
    } else if (empresa == 'Brumed') {
      logo = 'assets/images/logos/Icone_Brumed_03.png';
    }

    if (status == "Aguardando Aprovacao") {
      //color1Card = const Color.fromARGB(255, 5, 34, 58);
      //color2Card = const Color.fromARGB(255, 85, 170, 250);
      color1Card = const Color.fromARGB(255, 255, 255, 255);
      color2Card = const Color.fromARGB(255, 255, 255, 255);
      colorBorder = Colors.blue;
    } else if (status == "Pendente de Entrega") {
      color1Card = const Color.fromARGB(255, 255, 255, 255);
      color2Card = const Color.fromARGB(255, 162, 230, 255);
      colorBorder = Colors.red;
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
          border: Border(
            bottom: BorderSide(
              color: colorBorder,
            ),
            right: BorderSide(
              color: colorBorder,
            ),
          ),
        ),
        height: 200,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                width: widthScreen,
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
                          color: azulRoyalTopo),
                    ),
                    const SizedBox(height: 10),
                    if (pedido.fornecedor.length > 15)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fornecedor: ${pedido.fornecedor.substring(0, 15)}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulRoyalTopo,
                            ),
                          ),
                          Text(
                            pedido.fornecedor
                                .substring(15, pedido.fornecedor.length),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulRoyalTopo,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Fornecedor: ${pedido.fornecedor}',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: azulRoyalTopo,
                        ),
                      ),

                    const SizedBox(),
                    Text(
                      'Pedido: ${pedido.pedido}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: azulRoyalTopo,
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
                        color: azulRoyalTopo,
                      ),
                    ),
                    Text(
                      'Cond. Pgto: ${pedido.condicaoPagamento}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: azulRoyalTopo,
                      ),
                    ),
                    if (status == "Aguardando Aprovacao")
                      const SizedBox(height: 15),
                    if (status == "Pendente de Entrega")
                      Text(
                        'Comprador: ${pedido.comprador}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: azulRoyalTopo,
                        ),
                      ),
                    if (status == "Pendente de Entrega")
                      Text(
                        'Pedido Aprovado por: ${pedido.aprovadorPedido}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: azulRoyalTopo,
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (status == "Aguardando Aprovacao")
                      //const SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Provider.of<PedidosLista>(
                                  context,
                                  listen: false,
                                ).aprovarPedido(context, pedido);
                              },
                              child: SizedBox(
                                //width: 75,
                                //height: 75,
                                child: Image.asset(
                                  'assets/images/botoes/aprovar_tipo2.png',
                                  scale: 2.3,
                                ),
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     Provider.of<PedidosLista>(
                            //       context,
                            //       listen: false,
                            //     ).aprovarPedido(context, pedido);
                            //   },
                            //   icon: const Icon(Icons.beenhere_sharp,
                            //       color: Color.fromARGB(255, 34, 185, 39)),
                            //   iconSize: 30,
                            //   tooltip: "Aprovar",
                            // ),
                            const SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                Provider.of<PedidosLista>(
                                  context,
                                  listen: false,
                                ).reprovarPedido(context, pedido);
                              },
                              child: SizedBox(
                                //width: 75,
                                // height: 75,
                                child: Image.asset(
                                  'assets/images/botoes/reprovar_tipo2.png',
                                  scale: 2.3,
                                ),
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     Provider.of<PedidosLista>(
                            //       context,
                            //       listen: false,
                            //     ).reprovarPedido(context, pedido);
                            //   },
                            //   icon: const Icon(Icons.cancel,
                            //       color: Color.fromARGB(255, 155, 27, 27)),
                            //   iconSize: 30,
                            //   tooltip: "Reprovar",
                            // ),
                            const SizedBox(width: 25),
                            // IconButton(
                            //   onPressed: () {
                            //     Provider.of<PedidosLista>(
                            //       context,
                            //       listen: false,
                            //     ).loadItensPedidos(context, pedido);
                            //   },
                            //   icon: const Icon(Icons.list_alt),
                            //   color: Colors.white,
                            //   iconSize: 30,
                            //   tooltip: 'Vizualizar Pedido',
                            // ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<PedidosLista>(
                                  context,
                                  listen: false,
                                ).loadItensPedidos(context, pedido);
                              },
                              child: SizedBox(
                                // width: 75,
                                //height: 75,
                                child: Image.asset(
                                  'assets/images/botoes/visualizar_tipo2.png',
                                  scale: 2.3,
                                ),
                              ),
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
                            color: Colors.blue,
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
                    // if (status == "Aguardando Aprovacao")
                    //   const Row(
                    //     children: [
                    //       SizedBox(width: 50),
                    //       Text(
                    //         'Aprovar',
                    //         style: TextStyle(
                    //             color: Color.fromARGB(255, 34, 185, 39),
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(width: 35),
                    //       Text(
                    //         'Reprovar',
                    //         style: TextStyle(
                    //             color: Color.fromARGB(255, 155, 21, 21),
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(width: 20),
                    //       Text(
                    //         'Visualizar',
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ],
                    //   ),
                    if (status == "Pendente de Entrega")
                      const Row(
                        children: [
                          SizedBox(width: 50),
                          Text(
                            'Vizualizar',
                            style: TextStyle(
                                color: azulRoyalTopo,
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