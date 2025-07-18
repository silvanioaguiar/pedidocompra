import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ItensPedidoGridItem extends StatelessWidget {
  const ItensPedidoGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itensPedido = Provider.of<ItensPedidos>(context, listen: false);
    String valorTotal = NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
        .format(itensPedido.valor);
    String valorPrecoUnitario =
        NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
            .format(itensPedido.precoUnitario);
    String valorPrecoTotal =
        NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
            .format(itensPedido.precoTotal);
    String empresa = itensPedido.empresa;

    var logo;

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


    return ClipRect(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration:  BoxDecoration(
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
              borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                          const Text(
                            'Biosat Matriz Fábrica', //pedido.empresa,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 102, 245)),
                          ),
                          const SizedBox(),
                          const Text(
                            'Fornecedor: Teste',
                            // pedido.fornecedor.length > 25
                            //     ? 'Fornecedor: ${pedido.fornecedor.substring(0, 25)}'
                            //     : 'Fornecedor: ${pedido.fornecedor}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(),
                          const Text(
                            'Pedido: 0000001',
                            //'Pedido: ${pedido.pedido}',
                           
                            //'Pedido: ${itens[0]('empresa')}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(),
                          const Text(
                            'Valor Total do Pedido: 1250,00',
                            //'Valor Total do Pedido: ${valor1.toString()}',
                            //pedido.valor.toStringAsFixed(2),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'Cond.Pgeto: 30 dias',
                            //'Cond. Pgto: ${pedido.condicaoPagamento}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10, width: 100),
                          //Cabeçaho dos Itens
                          // Row(
                          //   //padding: EdgeInsets.all(15),
                          //   children: [
                          //     Table(
                          //       defaultVerticalAlignment:
                          //           TableCellVerticalAlignment.middle,
                          //       border: TableBorder.all(
                          //           width: 1, color: Colors.black45),
                          //       children: [
                          //         TableRow(children: [
                          //           TableCell(child: Text('Cod.Produto')),
                          //           TableCell(child: Text('Nome.Produto')),
                          //           TableCell(child: Text('Quant.')),
                          //           TableCell(child: Text('Prc.Unit')),
                          //           TableCell(child: Text('Prc.Total')),
                          //         ]),
                          //         TableRow(children: [
                          //           TableCell(child: Text('P.FGH.032.00')),
                          //           TableCell(
                          //               child: Text('Fio Guia Hidrofilico')),
                          //           TableCell(child: Text('1')),
                          //           TableCell(child: Text('99,00')),
                          //           TableCell(child: Text('99,00')),
                          //         ]),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                    
                          Row(
                            children: [
                              SizedBox(
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
                              SizedBox(
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
                              SizedBox(
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
                              SizedBox(
                                width: 80,
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
                              SizedBox(
                                width: 80,
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
                          // Itens
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'P.FGH.032.00'.length > 15
                                      ? 'P.FGH.032.00'.substring(0, 15)
                                      : 'P.FGH.032.00',
                                  // pedido.fornecedor.length > 25
                                  //     ? 'Fornecedor: ${pedido.fornecedor.substring(0, 25)}'
                                  //     : 'Fornecedor: ${pedido.fornecedor}',
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
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Fio Guia Hidrofilico 35'.length > 20
                                      ? 'Fio Guia Hidrofilico 35'.substring(0, 20)
                                      : 'Fio Guia Hidrofilico 35',
                                  style: const TextStyle(
                                    color:Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 55,
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: const Text(
                                  '99,00',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: const Text(
                                  '99,00',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'P.FGH.032.00'.length > 15
                                      ? 'P.FGH.032.00'.substring(0, 15)
                                      : 'P.FGH.032.00',
                                  // pedido.fornecedor.length > 25
                                  //     ? 'Fornecedor: ${pedido.fornecedor.substring(0, 25)}'
                                  //     : 'Fornecedor: ${pedido.fornecedor}',
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
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Fio Guia Hidrofilico 35'.length > 20
                                      ? 'Fio Guia Hidrofilico 35'.substring(0, 20)
                                      : 'Fio Guia Hidrofilico 35',
                                  style: const TextStyle(
                                    color:Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 55,
                                child: const Text(
                                  '1',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: const Text(
                                  '99,00',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: const Text(
                                  '99,00',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 95, 5, 5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100,),
                          Row(
                            children: [
                              const SizedBox(width: 120),
                              IconButton(
                                onPressed: () {
                                  // Provider.of<PedidosLista>(
                                  //   context,
                                  //   listen: false,
                                  // ).aprovarPedido(context, pedido);
                                },
                                icon: const Icon(Icons.beenhere_sharp,
                                    color: Color.fromARGB(255, 34, 185, 39)),
                                iconSize: 30,
                                tooltip: "Aprovar",
                              ),
                              const SizedBox(width: 60),
                              IconButton(
                                onPressed: () {
                                  // Provider.of<PedidosLista>(
                                  //   context,
                                  //   listen: false,
                                  // ).reprovarPedido(context, pedido);
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
      );
  }
}
