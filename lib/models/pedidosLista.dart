import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/pedidos.dart';

class PedidosLista with ChangeNotifier {
  final String _token;
  List<Pedidos> _pedidos = [];
  List<dynamic> data = [];
  int n = 0;
   
 

  List<Pedidos> get pedidos => [..._pedidos];

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
  
  data = jsonDecode(response.body);
  data.asMap(); 
     data.forEach((data) { 
       _pedidos.add(
        Pedidos(  
          empresa: data['principal']['dadospedidos']['empresa'],         
          pedido: data['principal']['pedido'],
          fornecedor: data['principal']['dadospedidos']['fornecedor'],          
          valor: data['principal']['dadospedidos']['valor'] == null ? 0.0 : data['principal']['dadospedidos']['valor'].toDouble() ,
          condicaoPagamento: data['principal']['dadospedidos']['condicaoPagamento'],            
         
       ),
       
     );
    });
    notifyListeners();    
  }


    
   Future<void> aprovarPedido() async {    

    final response = await http.post(
        Uri.parse(
            'http://192.168.1.5:8084/REST/api/biosat/v1/AprovarPedido/000926'),
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
  }
}
