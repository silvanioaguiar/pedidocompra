// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/models/crm/representantes.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class RepresentantesLista with ChangeNotifier {
  final String _token;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Representantes> _representantes = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Representantes> get representantes => [..._representantes];

  RepresentantesLista(this._token, this._representantes);

  int get representantesCount {
    return _representantes.length;
  }

  // Carregar Visitas

  Future<dynamic> loadRepresentantes(context) async {
    bool _isLoading = true;
    List<Representantes> representantes = [];
    _representantes.clear();
    representantes.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

   

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ListaRepresentantes'),
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
              'Nenhum representante encontrado.',
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
        representantes.add(
          Representantes(
            codigo: data['principal']['codigo'],
            nomeRepresentante: data['principal']['nomeRepresentante'],
          ),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
    return representantes;
  }
}
