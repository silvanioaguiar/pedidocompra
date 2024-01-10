import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/pedidoGrid.dart';
import 'package:pedidocompra/components/pedidoGridItem.dart';
import 'package:pedidocompra/models/empresas.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:pedidocompra/pages/menuEmpresas.dart';
import 'package:provider/provider.dart';

bool isLoading = true;

class PedidosPendentesAprovacao extends StatefulWidget {
  final String empresa;

  PedidosPendentesAprovacao({super.key, required this.empresa});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Pedidos Aguardando Aprovação",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : const PedidoGrid(),
      ),
      //drawer: const AppDrawer(),
    );
  }
}
