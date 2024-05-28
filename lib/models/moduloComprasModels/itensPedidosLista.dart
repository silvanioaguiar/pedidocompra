// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/routes/appRoutes.dart';

class ItensPedidosLista with ChangeNotifier {
  final String _token;
  final String _senha;
  //final String _empresa;
  List<ItensPedidos> _itensPedidos = [];
  List<dynamic> data = [];
  int n = 0;

  List<ItensPedidos> get pedidos => [..._itensPedidos];

  ItensPedidosLista(this._token, this._itensPedidos, this._senha);

  int get itensPedidosCount {
    return _itensPedidos.length;
  }

  //PedidosPendentesAprovacao get empresa => PedidosPendentesAprovacao(empresa: _empresa);

  Future<void> loadItensPedidos(empresa) async {
    // String pedido = Pedidos.pedido;
    // String empresa = Pedidos.empresa;
    List<ItensPedidos> pedidos = [];
    _itensPedidos.clear();

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/$empresa/$pedidos'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'Authorization': 'Bearer $_token',
        });

    data = jsonDecode(response.body);
    utf8.decode(response.bodyBytes);
    data.asMap();
    data.forEach((data) {
      pedidos.add(
        ItensPedidos(
          empresa: data['principal']['dadospedidos']['empresa'],
          pedido: data['principal']['pedido'],
          fornecedor: data['principal']['dadospedidos']['fornecedor'],
          valor: data['principal']['dadospedidos']['valor'] == null
              ? "0.0"
              : data['principal']['dadospedidos']['valor'],
          condicaoPagamento: data['principal']['dadospedidos']
              ['condicaoPagamento'],

          sc: data['principal']['dadospedidos']['sc'],
          solicitante: data['principal']['dadospedidos']['solicitante'],
          dataSC: data['principal']['dadospedidos']['dataSC'],
          aprovadorDaSC: data['principal']['dadospedidos']['aprovadorDaSC'],
          dataAprovacaoSC: data['principal']['dadospedidos']['dataAprovacaoSC'],
          comprador: data['principal']['dadospedidos']['comprador'],

          codProduto: data['principal']['dadospedidos']['codigoProduto'],
          nomeProduto: data['principal']['dadospedidos']['nomeProduto'],
          quantidade: data['principal']['dadospedidos']['quantidade'] == null
              ? 0.0
              : data['principal']['dadospedidos']['quantidade'].toDouble(),
          unidadeMedida: data['principal']['dadospedidos']['unidadeMedida'],
          precoUnitario: data['principal']['dadospedidos']['valorUnitario'] ==
                  null
              ? "0.0"
              : data['principal']['dadospedidos']['valorUnitario'],
          precoTotal: data['principal']['dadospedidos']['valorTotal'] == null
              ? "0.0"
              : data['principal']['dadospedidos']['valorTotal'],
          status: data['principal']['status'],
        ),
      );
    });

    

    notifyListeners();
  }

  Future<void> aprovarPedido(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;
    String empresaFilial = '';

    var data = Map();

    if (empresa == 'Libertad') {
      empresaFilial = '01,01';
    } else if (empresa == 'Biosat Matriz Fabrica') {
      empresaFilial = '02,01';
    } else if (empresa == 'Biosat Filial') {
      empresaFilial = '02,02';
    } else if (empresa == 'Big Assistencia Tecnica') {
      empresaFilial = '05,01';
    } else if (empresa == 'Big Locacao') {
      empresaFilial = '05,02';
    } else if (empresa == 'E-med') {
      empresaFilial = '06,01';
    } else if (empresa == 'Brumed') {
      empresaFilial = '08,01';
    }

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
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/$pedido/$empresa/$_senha'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Accept-Charset': 'utf-8',
                    'tenantId': empresaFilial,
                    'Authorization': 'Bearer $_token',
                  });

              if (response.body == 'null') return;

              if (response.statusCode == 500) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Erro',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Fechar",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 0, 0))),
                      ),
                    ],
                  ),
                );
              }

              notifyListeners();
              Navigator.of(context).pop();

              if (response.statusCode >= 200 && response.statusCode <= 299) {
                data = jsonDecode(response.body);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      data['MESSAGE'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      data['Mensagem Principal'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          loadItensPedidos(empresa);
                        },
                        child: const Text("Fechar",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 0, 0))),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text(
              "Sim",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 47, 82)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Não",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 196, 6, 6))),
          ),
        ],
      ),
    );
  }

  Future<void> reprovarPedido(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;
    String empresaFilial = '';

    var data = Map();

    if (empresa == 'Libertad') {
      empresaFilial = '01,01';
    } else if (empresa == 'Biosat Matriz Fabrica') {
      empresaFilial = '02,01';
    } else if (empresa == 'Biosat Filial') {
      empresaFilial = '02,02';
    } else if (empresa == 'Big Assistencia Tecnica') {
      empresaFilial = '05,01';
    } else if (empresa == 'Big Locacao') {
      empresaFilial = '05,02';
    } else if (empresa == 'E-med') {
      empresaFilial = '06,01';
    } else if (empresa == 'Brumed') {
      empresaFilial = '08,01';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Reprovar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja reprovar o pedido $pedido ?',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/$pedido/$empresa/$_senha'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Accept-Charset': 'utf-8',
                    'tenantId': empresaFilial,
                    'Authorization': 'Bearer $_token',
                  });

              if (response.body == 'null') return;

              if (response.statusCode == 500) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Erro',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Ocorreu um arro ao tentar reprovar o pedido.Por favor entrar em contato com o suporte do sistema',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Fechar",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 0, 0))),
                      ),
                    ],
                  ),
                );
              }

              notifyListeners();
              Navigator.of(context).pop();

              if (response.statusCode >= 200 && response.statusCode <= 299) {
                data = jsonDecode(response.body);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      data['MESSAGE'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      data['Mensagem Principal'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          loadItensPedidos(empresa);
                        },
                        child: const Text("Fechar",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 0, 0))),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text(
              "Sim",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 47, 82)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Não",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 196, 6, 6))),
          ),
        ],
      ),
    );
  }
}
