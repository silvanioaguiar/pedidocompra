// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/acessosAppModel.dart';
import 'package:pedidocompra/services/navigator_service.dart';

class AcessoApp with ChangeNotifier {
  final String _token;
  //final String _senha;
  //final String _empresa;
  List<AcessosAppModel> _acessos = [];
  List<dynamic> data = [];
  
  int n = 0;

  List<AcessosAppModel> get acessos => [..._acessos];

 AcessoApp(this._token, this._acessos);

  int get acessosCount {
    return _acessos.length;
  }


  // Carrega os acessos do usuário
  Future<dynamic> loadAcessos(context) async {
    List<AcessosAppModel> acessos = [];
    _acessos.clear();
    acessos.clear();
    
    Map<String, dynamic> data0 = {};
    data = [];   

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/AcessosApp'),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
          "Accept-Charset": "utf-8",
          'tenantId': "02,01",
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
              'Usuário sem Acesso ao Aplicativo.Por favor verificar com o suporte.',
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
    } else if (response.statusCode == 200)
     {
      data = jsonDecode(response.body);
      utf8.decode(response.bodyBytes);
      data.asMap();
      for (var data in data) {
        acessos.add(
          AcessosAppModel(
            acessoCompras: data['principal']['Compras'],
            acessoCrm: data['principal']['CRM'],                 
          ),
        );
      }
    }   

    notifyListeners();
    return acessos;
  }
}
