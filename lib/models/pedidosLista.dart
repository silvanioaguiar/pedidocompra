import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/pedidos.dart';

class PedidosLista with ChangeNotifier {
  final String _token;
  List<Pedidos> _pedidos = [];

  List<Pedidos> get pedidos => [..._pedidos];
  // String? empresa;
  // String? pedido;
  // String? fornecedor;
  // String? valor;
  // String? condicaoPagamento;

  PedidosLista(this._token, this._pedidos);

  int get pedidosCount {
    return _pedidos.length;
  }

  Future<void> loadPedidos() async {
    _pedidos.clear();

    final response = await http.get(
        Uri.parse(
            'http://192.168.1.5:8084/REST/api/biosat/v1/PedidosPendentes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        });

    if (response.body == 'null') return;

    // Map<String, dynamic> data = jsonEncode(response.body) as Map<String, dynamic>;
   // var data = jsonDecode(response.body.toString().replaceAll("\n",""));
    // var data = jsonDecode(jsonEncode(response.body));
   Map<String, dynamic> data = jsonDecode(response.body);
    //List<dynamic> data = jsonDecode(response.body);
    //data.asMap();
   data.forEach((pedido, dadospedido) {
      _pedidos.add(
        Pedidos(
          empresa: data['principal']['dadospedidos']['empresa'],
          pedido: data['principal']['pedido'],
          fornecedor: data['principal']['dadospedidos']['fornecedor'],
          valor: data['principal']['dadospedidos']['valor'],
          condicaoPagamento: data['principal']['dadospedidos']['condicaoPagamento'],  
          
          // empresa: data[0],
          // pedido: data[0],
          // forncedor: data[0],
          // valor: data[0],
          // condicaoPagamento: data[0],
          
       ),
     );
    });
    notifyListeners();
      

    // //var jsonResponse = json.decode(response.body);
    // List<dynamic> body = jsonDecode(response.body);
    // //body.map((json) => PedidosLista.fromMap(json)).toList()
    // //final body = jsonDecode(response.body);

    // //_empresa = body['Empresa'];
    // // (Map<String, dynamic> body) {
    // //   empresa = body['Empresa'];
    // //   pedido = body['Pedido'];
    // //   fornecedor = body['Fornecedor'];
    // //   valor = body['Valor'];
    // //   condicaoPagamento = body['Condicao Pagamento'];
    // // };

    // if (response.statusCode >= 200 && response.statusCode <= 299) {
    // } else if (response.statusCode >= 400 && response.statusCode <= 499) {
    // } else {}

    // notifyListeners();

    //isLoading = false;
  }
}
