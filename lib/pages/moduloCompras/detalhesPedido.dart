import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/comprasComponents/itensPedidoGrid.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/providers/compras/pedidosLista.dart';
import 'package:provider/provider.dart';

class DetalhesPedido extends StatefulWidget {
  final String empresa;
  final String pedido;

  const DetalhesPedido(
      {super.key, required this.empresa, required this.pedido});

  @override
  State<DetalhesPedido> createState() => _DetalhesPedidoState();
}

class _DetalhesPedidoState extends State<DetalhesPedido> {
  bool _isLoading = true;
  List<dynamic> data = [];
  String xempresa = '';
  String xpedido = '';

  @override
  void initState() {
    xempresa = widget.empresa;
    xpedido = widget.pedido;
    super.initState();
    Provider.of<PedidosLista>(
      context,
      listen: false,
    ).loadItensPedidos(xempresa, xpedido).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Vizualizar",
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : const ItensPedidoGrid(),
      ),
      // : Container(

      // ),
    );
    //drawer: const AppDrawer(),
  }
}
