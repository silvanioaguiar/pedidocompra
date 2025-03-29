// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/services/navigator_service.dart';


class ConcorrentesLista with ChangeNotifier {
  final String _token;

  List<Concorrentes> _concorrentes = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Concorrentes> get concorrentes => [..._concorrentes];

  ConcorrentesLista(this._token, this._concorrentes);

  int get concorrentesCount {
    return _concorrentes.length;
  }

  // Carregar Concorrentes

  Future<dynamic> loadConcorrentes(context) async {
    List<Concorrentes> concorrentes = [];
    _concorrentes.clear();
    concorrentes.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ListaConcorrentes'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'tenantId': '02,01', // fixado como Biosat Matriz
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
              'Nenhum concorrente cadastrado.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  NavigatorService.instance.pop();
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
    } else if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      utf8.decode(response.bodyBytes);
      data.asMap();
      for (var data in data) {
        concorrentes.add(
          Concorrentes(
            codigo: data['principal']['codigo'],
            razaoSocial: data['principal']['razaoSocial'],
            nomeFantasia: data['principal']['nomeFantasia'],
            endereco: data['principal']['endereco'] ?? "",
            municipio: data['principal']['municipio'] ?? "",
            estado: data['principal']['estado'] ?? "",
            bairro: data['principal']['bairro'] ?? "",
            cep: data['principal']['cep'] ?? "",
            ddd: data['principal']['ddd'] ?? "",
            telefone: data['principal']['telefone'] ?? "",
            contato: data['principal']['contato'] ?? "",
            homePage: data['principal']['homePage'] ?? "",
          ),
        );
      }
    }
    _concorrentes = concorrentes;

    notifyListeners();
    return _concorrentes;
  }

  Future<dynamic> editarConcorrente(context, dadosConcorrente) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EditarConcorrente');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigo': dadosConcorrente['codigo'],
      'razaoSocial': dadosConcorrente['razaoSocial'],
      'nomeFantasia': dadosConcorrente['nomeFantasia'],
      'endereco': dadosConcorrente['endereco'],
      'municipio': dadosConcorrente['municipio'],
      'estado': dadosConcorrente['estado'],
      'bairro': dadosConcorrente['bairro'],
      'cep': dadosConcorrente['cep'],
      'ddd': dadosConcorrente['ddd'],
      'telefone': dadosConcorrente['telefone'],
      'contato': dadosConcorrente['contato'],
      'homePage': dadosConcorrente['homePage'],
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 500) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'ATENÇÃO!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
            'Não foi possivel editar o concorrente. Contate o administrador do sistema',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                NavigatorService.instance.pop();
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
    } else if (response.statusCode >= 200 && response.statusCode <= 299) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'ATENÇÃO!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
            'Concorrente atualizado com sucesso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Fecha a tela principal
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
    await loadConcorrentes(context);
  }

  Future<dynamic> incluirConcorrente(context, dadosConcorrente) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/IncluirConcorrente');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({       
      'razaoSocial': dadosConcorrente['razaoSocial'],
      'nomeFantasia': dadosConcorrente['nomeFantasia'],
      'endereco': dadosConcorrente['endereco'],
      'municipio': dadosConcorrente['municipio'],
      'estado': dadosConcorrente['estado'],
      'bairro': dadosConcorrente['bairro'],
      'cep': dadosConcorrente['cep'],
      'ddd': dadosConcorrente['ddd'],
      'telefone': dadosConcorrente['telefone'],
      'contato': dadosConcorrente['contato'],
      'homePage': dadosConcorrente['homePage'],
    });

    final response = await http.put(uri, headers: headers, body: body);

    if (response.statusCode == 500) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'ATENÇÃO!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
            'Não foi possivel incluir o concorrente. Contate o administrador do sistema',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                NavigatorService.instance.pop();
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
    } else if (response.statusCode >= 200 && response.statusCode <= 299) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'ATENÇÃO!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
            'Concorrente incluído com sucesso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Fecha a tela principal
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
    await loadConcorrentes(context);
  }
}
