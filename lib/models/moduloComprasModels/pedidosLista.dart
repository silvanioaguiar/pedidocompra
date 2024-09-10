// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidos.dart';
import 'package:pedidocompra/pages/moduloCompras/itensPedido.dart';
import 'package:pedidocompra/pages/moduloCompras/menuEmpresas.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class PedidosLista with ChangeNotifier {
  final String _token;
  //final String _senha;
  //final String _empresa;
  List<Pedidos> _pedidos = [];
  List<dynamic> data = [];
  List<dynamic> data2 = [];
  Map<String, dynamic> data0 = {};
  List<ItensPedidos> _itensDoPedido = [];
  int n = 0;

  List<Pedidos> get pedidos => [..._pedidos];
  List<ItensPedidos> get itensDoPedido => [..._itensDoPedido];

  PedidosLista(this._token, this._pedidos, this._itensDoPedido);

  int get pedidosCount {
    return _pedidos.length;
  }

  int get itensPedidosCount {
    return _itensDoPedido.length;
  }

  //PedidosPendentesAprovacao get empresa => PedidosPendentesAprovacao(empresa: _empresa);

  Future<void> loadPedidos(context, empresa) async {
    List<Pedidos> pedidos = [];
    _pedidos.clear();
    pedidos.clear();
    String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

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

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/$empresa'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'tenantId': empresaFilial,
          'Authorization': 'Bearer $_token',
        });

    if (response.statusCode == 500) {
      data0 = jsonDecode(response.body);

      if (data0['errorMessage'] ==
          'Não existem dados para serem apresentados') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
              'Não tem pedidos pendentes de aprovação para o seu usuário nessa empresa no momento.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  NavigatorService
                  .instance
                  .pop();                 
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
    } else if (response.statusCode == 200 &&
        response.body ==
            '{"Mensagem Principal":"Usuário não cadastrado como aprovador para essa empresa.","RETURN":true,"MESSAGE":"Usuário não cadastrado."}') {
      data0 = jsonDecode(response.body);

      if (data0['MESSAGE'] == 'Usuário não cadastrado.') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
              'Usuário não cadastrado como aprovador para essa empresa.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(                
                onPressed: () {
                  NavigatorService
                  .instance
                  .pop();                 
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
    } else {
      data = jsonDecode(response.body);
      utf8.decode(response.bodyBytes);
      data.asMap();
      for (var data in data) {
        pedidos.add(
          Pedidos(
            empresa: data['principal']['dadospedidos']['empresa'],
            pedido: data['principal']['pedido'],
            fornecedor: data['principal']['dadospedidos']['fornecedor'],
            valor: data['principal']['dadospedidos']['valor'] ?? "0.0",
            condicaoPagamento: data['principal']['dadospedidos']
                ['condicaoPagamento'],
            status: data['principal']['status'], 
            comprador: data['principal']['dadospedidos']['comprador'],  
            aprovadorPedido: data['principal']['dadospedidos']['aprovador'],           
          ),
        );
      }
    }
   
    _pedidos = pedidos.reversed.toList();
   

    notifyListeners();
  }

  //Future<void> loadItensPedidos(context, Pedidos) async {
  Future<void> loadItensPedidos(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;

    List<ItensPedidos> itensDoPedido = [];
    _itensDoPedido.clear();
    itensDoPedido.clear();

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/$empresa/$pedido'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'Authorization': 'Bearer $_token',
        });

    //if (response.body == 'null') return;

    //data = jsonDecode(response.body);

    data2 = jsonDecode(response.body);
    utf8.decode(response.bodyBytes);
    data2.asMap();
    for (var data2 in data2) {
      itensDoPedido.add(
        ItensPedidos(
          empresa: data2['principal']['dadospedidos']['empresa'],
          pedido: data2['principal']['pedido'],
          fornecedor: data2['principal']['dadospedidos']['fornecedor'],
          valor: data2['principal']['dadospedidos']['valor'] ?? "0.0",
          condicaoPagamento: data2['principal']['dadospedidos']
              ['condicaoPagamento'],
          sc: data2['principal']['dadospedidos']['sc'],
          solicitante: data2['principal']['dadospedidos']['solicitante'],
          dataSC: data2['principal']['dadospedidos']['dataSC'],
          aprovadorDaSC: data2['principal']['dadospedidos']['aprovadorDaSC'],
          dataAprovacaoSC: data2['principal']['dadospedidos']['dataAprovacaoSC'],
          comprador: data2['principal']['dadospedidos']['comprador'],
          codProduto: data2['principal']['dadospedidos']['codigoProduto'],
          nomeProduto: data2['principal']['dadospedidos']['nomeProduto'],
          quantidade: data2['principal']['dadospedidos']['quantidade'] == null
              ? 0.0
              : data2['principal']['dadospedidos']['quantidade'].toDouble(),
          unidadeMedida: data2['principal']['dadospedidos']['unidadeMedida'],
          precoUnitario: data2['principal']['dadospedidos']['valorUnitario'] ?? "0.0",
          precoTotal: data2['principal']['dadospedidos']['valorTotal'] ?? "0.0",
          status: data2['principal']['status'],
        ),
      );
    }

    //_pedidos.reversed.toList();
    notifyListeners();
    //itensDoPedido.asMap();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItensPedido(
                  itensPedido: itensDoPedido,
                )));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Atualizando...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> aprovarPedido(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;
    String empresaFilial = '';

    var data = {};

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
              Navigator.pop(context);
              showLoaderDialog(context);
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/Aprovar/$pedido/$empresa'),
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
              Navigator.of(context, rootNavigator: true).pop();

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
                          Navigator.of(context, rootNavigator: true).pop();
                          

                          Provider.of<PedidosLista>(
                            context,
                            listen: false,
                          ).loadPedidos(context, empresa);

                          //Navigator.of(context, rootNavigator: true).pop();
                          //Navigator.of(context).pop();

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (ctx) {
                          //     return PedidosPendentesAprovacao(
                          //         empresa: empresa);
                          //   }),
                          // );
                          // loadPedidos(context, empresa);
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

  Future<void> aprovarPedidoemVisualizar(context, pedido, empresa) async {
    String empresaFilial = '';

    var data = {};

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
              Navigator.pop(context);
              showLoaderDialog(context);
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/Aprovar/$pedido/$empresa'),
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
                        onPressed: () {
                          Navigator.of(context).pop();
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

              notifyListeners();
              Navigator.of(context, rootNavigator: true).pop();

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
                          Navigator.of(context, rootNavigator: true).pop();

                          Provider.of<PedidosLista>(
                            context,
                            listen: false,
                          ).loadPedidos(context, empresa);

                          Navigator.of(context, rootNavigator: true).pop();

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (ctx) {
                          //     return PedidosPendentesAprovacao(
                          //         empresa: empresa);
                          //   }),
                          // );
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

    var data = {};

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
              Navigator.pop(context);
              showLoaderDialog(context);
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/Reprovar/$pedido/$empresa'),
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
                        onPressed: () {
                          Navigator.of(context).pop();
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

              notifyListeners();
              Navigator.of(context, rootNavigator: true).pop();

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
                          Navigator.of(context, rootNavigator: true).pop();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (ctx) {
                          //     return PedidosPendentesAprovacao(
                          //         empresa: empresa);
                          //   }),
                          // );
                          Provider.of<PedidosLista>(
                            context,
                            listen: false,
                          ).loadPedidos(context, empresa);
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

  Future<void> reprovarPedidoemVisualizar(context, pedido, empresa) async {
    String empresaFilial = '';

    var data = {};

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
              Navigator.pop(context);
              showLoaderDialog(context);
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/Reprovar/$pedido/$empresa'),
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
                        onPressed: () {
                          Navigator.of(context).pop();
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

              notifyListeners();
              Navigator.of(context, rootNavigator: true).pop();

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
                          Navigator.of(context, rootNavigator: true).pop();                       
                          Provider.of<PedidosLista>(
                            context,
                            listen: false,
                          ).loadPedidos(context, empresa);
                          Navigator.of(context, rootNavigator: true).pop();
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

  Future<void> loadPendentesEntrega(context, empresa) async {
    List<Pedidos> pedidos = [];
    _pedidos.clear();
    pedidos.clear();
    String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

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

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/PendentesEntrega/$empresa'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'tenantId': empresaFilial,
          'Authorization': 'Bearer $_token',
        });

    if (response.statusCode == 500) {
      data0 = jsonDecode(response.body);

      if (data0['errorMessage'] ==
          'Não existem dados para serem apresentados') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
              'Não tem pedidos pendentes de aprovação para o seu usuário nessa empresa no momento.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  NavigatorService
                  .instance
                  .pop();                 
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
    } else if (response.statusCode == 200 &&
        response.body ==
            '{"Mensagem Principal":"Usuário não cadastrado como aprovador para essa empresa.","RETURN":true,"MESSAGE":"Usuário não cadastrado."}') {
      data0 = jsonDecode(response.body);

      if (data0['MESSAGE'] == 'Usuário não cadastrado.') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
              'Usuário não cadastrado como aprovador para essa empresa.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(                
                onPressed: () {
                  NavigatorService
                  .instance
                  .pop();                 
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
    } else {
      data = jsonDecode(response.body);
      utf8.decode(response.bodyBytes);
      data.asMap();
      for (var data in data) {
        pedidos.add(
          Pedidos(
            empresa: data['principal']['dadospedidos']['empresa'],
            pedido: data['principal']['pedido'],
            fornecedor: data['principal']['dadospedidos']['fornecedor'],
            valor: data['principal']['dadospedidos']['valor'] ?? "0.0",
            condicaoPagamento: data['principal']['dadospedidos']
                ['condicaoPagamento'], 
            status: data['principal']['status'], 
            comprador: data['principal']['dadospedidos']['comprador'],  
            aprovadorPedido: data['principal']['dadospedidos']['aprovador'],        
          ),
        );
      }
    }
   
    _pedidos = pedidos.reversed.toList();
   

    notifyListeners();
  }

  Future<void> loadItensPendentesEntrega(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;

    List<ItensPedidos> itensDoPedido = [];
    _itensDoPedido.clear();
    itensDoPedido.clear();

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/itensEntregaPedidosPendentes/$empresa/$pedido'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'Authorization': 'Bearer $_token',
        });

    //if (response.body == 'null') return;

    //data = jsonDecode(response.body);

    data2 = jsonDecode(response.body);
    utf8.decode(response.bodyBytes);
    data2.asMap();
    for (var data2 in data2) {
      itensDoPedido.add(
        ItensPedidos(
          empresa: data2['principal']['dadospedidos']['empresa'],
          pedido: data2['principal']['pedido'],
          fornecedor: data2['principal']['dadospedidos']['fornecedor'],
          valor: data2['principal']['dadospedidos']['valor'] ?? "0.0",
          condicaoPagamento: data2['principal']['dadospedidos']
              ['condicaoPagamento'],
          sc: data2['principal']['dadospedidos']['sc'],
          solicitante: data2['principal']['dadospedidos']['solicitante'],
          dataSC: data2['principal']['dadospedidos']['dataSC'],
          aprovadorDaSC: data2['principal']['dadospedidos']['aprovadorDaSC'],
          dataAprovacaoSC: data2['principal']['dadospedidos']['dataAprovacaoSC'],
          comprador: data2['principal']['dadospedidos']['comprador'],
          codProduto: data2['principal']['dadospedidos']['codigoProduto'],
          nomeProduto: data2['principal']['dadospedidos']['nomeProduto'],
          quantidade: data2['principal']['dadospedidos']['quantidade'] == null
              ? 0.0
              : data2['principal']['dadospedidos']['quantidade'].toDouble(),
          unidadeMedida: data2['principal']['dadospedidos']['unidadeMedida'],
          precoUnitario: data2['principal']['dadospedidos']['valorUnitario'] ?? "0.0",
          precoTotal: data2['principal']['dadospedidos']['valorTotal'] ?? "0.0",
          status: data2['principal']['status'],
        ),
      );
    }

    //_pedidos.reversed.toList();
    notifyListeners();
    //itensDoPedido.asMap();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItensPedido(
                  itensPedido: itensDoPedido,
                )));
  }

  Future<void> estornarLiberacao(context, Pedidos) async {
    String pedido = Pedidos.pedido;
    String empresa = Pedidos.empresa;
    String empresaFilial = '';

    var data = {};

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
          'Estornar Liberação',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja estornar liberação do pedido $pedido ?',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              showLoaderDialog(context);
              final response = await http.put(
                  Uri.parse(
                      'http://biosat.dyndns.org:8084/REST/api/biosat/v1/PedidosPendentes/Estornar/$pedido/$empresa'),
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
                      'Ocorreu um arro ao tentar estornar a liberação do pedido.Por favor entrar em contato com o suporte do sistema',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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

              notifyListeners();
              Navigator.of(context, rootNavigator: true).pop();

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
                          Navigator.of(context, rootNavigator: true).pop();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (ctx) {
                          //     return PedidosPendentesAprovacao(
                          //         empresa: empresa);
                          //   }),
                          // );
                          Provider.of<PedidosLista>(
                            context,
                            listen: false,
                          ).loadPendentesEntrega(context, empresa);
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
