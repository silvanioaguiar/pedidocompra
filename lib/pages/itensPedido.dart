import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ItensPedido extends StatefulWidget {
  //Map? itensDoPedido;
  List<dynamic> itensPedido;
  ItensPedido({Key? key, required this.itensPedido}) : super(key: key);

  @override
  State<ItensPedido> createState() => _ItensPedidoState();
}

class _ItensPedidoState extends State<ItensPedido> {
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Orientation orientation = MediaQuery.of(context).orientation;
    //final bool isLandscape = orientation == Orientation.landscape;

    List<dynamic> itensDoPedido = widget.itensPedido;
    String valorTotal = NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
        .format(itensDoPedido[0].valor);

    var logo;
    String empresa = itensDoPedido[0].empresa;

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

    return Scaffold(
      //primary: !isLandscape,

      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Itens do Pedido",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: ClipRect(
        child: Padding(
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
                  Color.fromARGB(255, 231, 235, 238),
                  Color.fromARGB(255, 85, 170, 250),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage(logo),
                alignment: Alignment.topRight,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                            itensDoPedido[0].empresa,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 102, 245)),
                          ),
                          const SizedBox(),
                          Text(
                            itensDoPedido[0].fornecedor.length > 25
                                ? 'Fornecedor: ${itensDoPedido[0].fornecedor.substring(0, 25)}'
                                : 'Fornecedor: ${itensDoPedido[0].fornecedor}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(),
                          Text(
                            'Pedido: ${itensDoPedido[0].pedido}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(),
                          Text(
                            //'Valor Total do Pedido: 1250,00',

                            'Valor Total do Pedido: ${valorTotal.toString()}',
                            //pedido.valor.toStringAsFixed(2),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            //'Cond.Pgeto: 30 dias',
                            'Cond. Pgto: ${itensDoPedido[0].condicaoPagamento}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10, width: 100),
                          Row(
                            children: [
                              Container(
                                width: 120,
                                child: const Text(
                                  'Cod.Produto',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 150,
                                child: const Text(
                                  'Nome Produto',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 55,
                                child: const Text(
                                  'Quant.',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 40,
                                child: const Text(
                                  'U.M.',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 90,
                                child: const Text(
                                  'Prc.Unit',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 90,
                                child: const Text(
                                  'Prc.Total',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 1, 44, 78),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(),
                          for (int item = 0;
                              item < itensDoPedido.length;
                              item++)
                            Row(
                              children: [
                                Container(
                                  width: 120,
                                  child: Text(
                                    itensDoPedido[item].codProduto.length > 15
                                        ? itensDoPedido[item]
                                            .codProduto
                                            .substring(0, 15)
                                        : itensDoPedido[item].codProduto,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 150,
                                  child: Text(
                                    itensDoPedido[item].nomeProduto.length > 30
                                        ? itensDoPedido[item]
                                            .nomeProduto
                                            .substring(0, 30)
                                        : itensDoPedido[item].nomeProduto,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 55,
                                  child: Text(
                                    itensDoPedido[item].quantidade.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 40,
                                  child: Text(
                                    itensDoPedido[item].unidadeMedida,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 90,
                                  child: Text(
                                    NumberFormat.currency(
                                            locale: 'br_Br', symbol: "R\$")
                                        .format(
                                            itensDoPedido[item].precoUnitario)
                                        .toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 90,
                                  child: Text(
                                    //precoTotal,
                                    NumberFormat.currency(
                                            locale: 'br_Br', symbol: "R\$")
                                        .format(itensDoPedido[item].precoTotal)
                                        .toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 95, 5, 5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 120),
                              IconButton(
                                onPressed: () {
                                  Provider.of<PedidosLista>(
                                    context,
                                    listen: false,
                                  ).aprovarPedidoemVisualizar(
                                      context,
                                      itensDoPedido[0].pedido,
                                      itensDoPedido[0].empresa);

                                  
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
                                  ).reprovarPedidoemVisualizar(
                                      context,
                                      itensDoPedido[0].pedido,
                                      itensDoPedido[0].empresa);
                                },
                                icon: const Icon(Icons.cancel,
                                    color: Color.fromARGB(255, 155, 27, 27)),
                                iconSize: 30,
                                tooltip: "Reprovar",
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 120),
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
