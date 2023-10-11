import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/components/authForm.dart';
import 'package:pedidocompra/models/pedidos.dart';

class PedidosLista with ChangeNotifier {
  final String _token;
  final String _senha;
  final String _empresa;
  List<Pedidos> _pedidos = [];
  List<dynamic> data = [];
  int n = 0;

  List<Pedidos> get pedidos => [..._pedidos];

  PedidosLista(this._token, this._pedidos,this._senha,this._empresa);

  int get pedidosCount {
    return _pedidos.length;
  }

  Future<void> loadPedidos(empresa) async {
    List<Pedidos> pedidos = [];

    final response = await http.get(
        Uri.parse(
            'http://192.168.1.5:8084/REST/api/biosat/v1/PedidosPendentes/$_empresa'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        });

    if (response.body == 'null') return;

    data = jsonDecode(response.body);
    data.asMap();
    data.forEach((data) {
      pedidos.add(
        Pedidos(
          empresa: data['principal']['dadospedidos']['empresa'],
          pedido: data['principal']['pedido'],
          fornecedor: data['principal']['dadospedidos']['fornecedor'],
          valor: data['principal']['dadospedidos']['valor'] == null
              ? 0.0
              : data['principal']['dadospedidos']['valor'].toDouble(),
          condicaoPagamento: data['principal']['dadospedidos']
              ['condicaoPagamento'],
        ),
      );
    });
    _pedidos = pedidos.reversed.toList();
    notifyListeners();
  }

  Future<void> aprovarPedido(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Aprovação',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja aprovar o pedido $pedido ?',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await http.put(
                  Uri.parse(
                      'http://192.168.1.5:8084/REST/api/biosat/v1/PedidosPendentes/$pedido/$empresa/$_senha'),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $_token',
                  });

              if (response.body == 'null') return;

              // data = jsonDecode(response.body);
              // data.asMap();
              //    data.forEach((data) {
              //      _pedidos.add(
              //       Pedidos(
              //         empresa: data['principal']['dadospedidos']['empresa'],
              //         pedido: data['principal']['pedido'],
              //         fornecedor: data['principal']['dadospedidos']['fornecedor'],
              //         valor: data['principal']['dadospedidos']['valor'] == null ? 0.0 : data['principal']['dadospedidos']['valor'].toDouble() ,
              //         condicaoPagamento: data['principal']['dadospedidos']['condicaoPagamento'],

              //      ),

              //    );
              //   });
              notifyListeners();
              Navigator.of(context).pop();
            },
            child: const Text("Sim",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 47, 82)),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Não",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 196, 6, 6))),
          ),
        ],
      ),
    );
  }
}
