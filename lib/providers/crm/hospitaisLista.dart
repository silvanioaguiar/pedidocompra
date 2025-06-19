// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/hospitais.dart';
import 'package:pedidocompra/services/navigator_service.dart';

class HospitaisLista with ChangeNotifier {
  final String _token;

  List<Hospitais> _hospitais = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Hospitais> get hospitais => [..._hospitais];

  HospitaisLista(this._token, this._hospitais);

  int get hospitaisCount {
    return _hospitais.length;
  }

  // Carregar Visitas

  Future<dynamic> loadHospitais(context) async {
    List<Hospitais> hospitais = [];
    _hospitais.clear();
    hospitais.clear();
    Map<String, dynamic> data0 = {};
    data = [];
    var decodedBody;

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ListaHospitais'),
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
              'Nenhum hospitais encontrado',
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
        hospitais.add(
          Hospitais(
            codigo: data['principal']['codigoHospital'],
            nomeHospital: data['principal']['nomeHospital'],
          ),
        );
      }
    }

    notifyListeners();
    return hospitais;
  }
}
