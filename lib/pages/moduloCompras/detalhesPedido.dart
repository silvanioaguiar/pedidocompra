import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/comprasComponents/itensPedidoGrid.dart';
import 'package:pedidocompra/models/moduloComprasModels/itensPedidosLista.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidosLista.dart';
import 'package:provider/provider.dart';

class DetalhesPedido extends StatefulWidget {
  final String empresa;
  final String pedido;

  DetalhesPedido({super.key, required this.empresa, required this.pedido});

   

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
    ).loadItensPedidos(xempresa,xpedido).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const ItensPedidoGrid(),
          // : Container(

          // ),
    );
    //drawer: const AppDrawer(),
  }
}
