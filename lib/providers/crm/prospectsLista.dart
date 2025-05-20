// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/propects.dart';
import 'package:pedidocompra/services/navigator_service.dart';


class ProspectsLista with ChangeNotifier {
  final String _token;

  List<Prospects> _prospects = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Prospects> get prospects => [..._prospects];

  ProspectsLista(this._token, this._prospects);

  int get prospectsCount {
    return _prospects.length;
  }

  // Carregar Prospects
  Future<dynamic> loadProspects(context) async {
    String jsonString = '';
    List<Prospects> prospects = [];
    _prospects.clear();
    prospects.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ListaProspects'),
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
              'Nenhum prospect cadastrado.',
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
      //data = jsonDecode(response.body);
      jsonString = utf8.decode(response.bodyBytes, allowMalformed: true);
      data = jsonDecode(jsonString);
      data.asMap();
      for (var data in data) {
        prospects.add(
          Prospects(
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
            tipo: data['principal']['tipo'] ?? "",
          ),
        );
      }
    }
    _prospects = prospects;

    notifyListeners();
    return _prospects;
  }

  Future<dynamic> editarProspects(context, dadosProspect) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EditarProspect');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigo': dadosProspect['codigo'],
      'razaoSocial': dadosProspect['razaoSocial'],
      'nomeFantasia': dadosProspect['nomeFantasia'],
      'endereco': dadosProspect['endereco'],
      'municipio': dadosProspect['municipio'],
      'estado': dadosProspect['estado'],
      'bairro': dadosProspect['bairro'],
      'cep': dadosProspect['cep'],
      'ddd': dadosProspect['ddd'],
      'telefone': dadosProspect['telefone'],
      'contato': dadosProspect['contato'],
      'tipo': dadosProspect['tipo'],
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
            'Não foi possivel editar o prospect. Contate o administrador do sistema',
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
            'Prospect atualizado com sucesso',
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
    await loadProspects(context);
  }

  Future<dynamic> bloquearProspect(context, codigoProspect) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/BloquearProspect');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigo': codigoProspect,
      
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
            'Não foi possivel bloquear o prospect. Contate o administrador do sistema',
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
            'Prospect bloqueado com sucesso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog                
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
    await loadProspects(context);
  }

  Future<dynamic> incluirProspect(context, dadosProspect) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/IncluirProspect');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({       
      'razaoSocial': dadosProspect['razaoSocial'],
      'nomeFantasia': dadosProspect['nomeFantasia'],
      'endereco': dadosProspect['endereco'],
      'municipio': dadosProspect['municipio'],
      'estado': dadosProspect['estado'],
      'bairro': dadosProspect['bairro'],
      'cep': dadosProspect['cep'],
      'ddd': dadosProspect['ddd'],
      'telefone': dadosProspect['telefone'],
      'contato': dadosProspect['contato'],
      'tipo': dadosProspect['tipo'],
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
            'Não foi possivel incluir o prospect. Contate o administrador do sistema',
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
            'Prospect incluído com sucesso',
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
    await loadProspects(context);
  }
}
