import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/comprasComponents/pedidoGrid.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/providers/compras/pedidosLista.dart';
import 'package:provider/provider.dart';

bool isLoading = true;

class PedidosPendentesAprovacao extends StatefulWidget {
  final String empresa;

  const PedidosPendentesAprovacao({super.key, required this.empresa});

  @override
  State<PedidosPendentesAprovacao> createState() =>
      _PedidosPendentesAprovacaoState();
}

class _PedidosPendentesAprovacaoState extends State<PedidosPendentesAprovacao> {
  bool _isLoading = true;

  String xempresa = '';

  @override
  void initState() {
    xempresa = widget.empresa;
    super.initState();
    Provider.of<PedidosLista>(
      context,
      listen: false,
    ).loadPedidos(context, xempresa).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<PedidosLista>(
      context,
      listen: false,
    ).loadPedidos(context, xempresa);
  }

  Future<void> _refreshPendentesEntrega(BuildContext context) {
    return Provider.of<PedidosLista>(
      context,
      listen: false,
    ).loadPendentesEntrega(context, xempresa);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    //final double itemWidth = size.width / 2;
    final double itemWidth = size.width;
    final ScrollController mycontroller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Pedidos e Status",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/fundos/FUNDO_BIOSAT_APP_02_640.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                     GestureDetector(
                              onTap: () {
                               _refreshProducts(context);
                              },
                              child: SizedBox(
                                //  width: 200,
                                //  height: 150,
                                child: Image.asset(
                                  'assets/images/botoes/botao_Aprovacao_02.png',
                                  scale: 1.8,
                                ),
                              ),
                            ),
                  // TextButton.icon(
                  //   onPressed: () {
                  //     _refreshProducts(context);
                  //   },
                  //   icon: const Icon(
                  //     //Icons.toggle_on,
                  //     Icons.check,
                  //     size: 25,
                  //     color: Color.fromARGB(255, 251, 251, 251),
                  //   ),
                  //   label: const Text('Aguard. Aprovação',
                  //       style: TextStyle(
                  //         color: Color.fromARGB(255, 249, 249, 250),
                  //       )),
                  //   style: TextButton.styleFrom(
                  //     padding: const EdgeInsets.all(5),
                  //     backgroundColor: const Color.fromARGB(255, 14, 69, 114),
                  //     foregroundColor: const Color.fromARGB(255, 245, 245, 245),
                  //     //disabledBackgroundColor:  const Color.fromARGB(255, 100, 45, 45),
                  //   ),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                              onTap: () {
                               _refreshPendentesEntrega(context);
                              },
                              child: SizedBox(
                                //  width: 200,
                                //  height: 150,
                                child: Image.asset(
                                  'assets/images/botoes/botao_Entrega_02.png',
                                  scale: 1.8,
                                ),
                              ),
                            ),
                  // TextButton.icon(
                  //   onPressed: () {
                  //     _refreshPendentesEntrega(context);
                  //   },
                  //   icon: const Icon(
                  //     //Icons.toggle_on,
                  //     Icons.timelapse_rounded,
                  //     size: 25,
                  //     color: Color.fromARGB(255, 254, 254, 254),
                  //   ),
                  //   label: const Text('Pendentes Entrega',
                  //       style: TextStyle(
                  //         color: Color.fromARGB(255, 249, 250, 250),
                  //       )),
                  //   style: TextButton.styleFrom(
                  //     padding: const EdgeInsets.all(5),
                  //     backgroundColor: const Color.fromARGB(255, 108, 20, 14),
                  //     foregroundColor: const Color.fromARGB(255, 245, 245, 245),
                  //   ),
                  // ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const PedidoGrid(),
            ),
          ],
        ),
      ),
      //drawer: const AppDrawer(),
    );
  }
}
