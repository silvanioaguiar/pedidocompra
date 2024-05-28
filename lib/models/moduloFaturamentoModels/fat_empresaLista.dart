// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';


class FatEmpresaLista with ChangeNotifier {
  final String _token;
  //final String _senha;
  //final String _empresa;
  List<FaturamentoEmpresas> _empresas = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};
  int n = 0;

  List<FaturamentoEmpresas> get empresas => [..._empresas];
 

  FatEmpresaLista(this._token, this._empresas);

  int get empresasCount {
    return _empresas.length;
  }

  
 
  
  Future<void> loadEmpresas(context, empresa,dataIni,dataFim) async {
    List<FaturamentoEmpresas> empresas = [];
    _empresas.clear();
    empresas.clear();
    String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    empresa = 'Biosat Matriz Fabrica';
    empresaFilial = '02,01';
    

    final response = await http.get(
        Uri.parse(            
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/FaturamentoEmpresas/$dataIni/$dataFim'),
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
              'Não tem dados a serem a apresentados!',
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
            '{"Mensagem Principal":"Usuário não cadastrado para acessar essa rotina.","RETURN":true,"MESSAGE":"Usuário não cadastrado."}') {
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
              'Usuário não cadastrado para acessar essa rotina.',
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
      data.forEach((data) {
        empresas.add(
          FaturamentoEmpresas(
            empresa: data['principal']['empresa'],               
   
            valorReal: data['principal']['valor'], 
            
            //ranking:  data['principal']['ranking'],             
          ),
        );
      });
    }
   
    _empresas = empresas.toList();
   

    notifyListeners();
  }

  

}
