// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_convenio.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';


class FatConvenioLista with ChangeNotifier {
  final String _token;
  //final String _senha;
  //final String _empresa;
  List<FaturamentoConvenio> _convenios = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};
  int n = 0;

  List<FaturamentoConvenio> get convenios => [..._convenios];
 

  FatConvenioLista(this._token, this._convenios);

  int get conveniosCount {
    return _convenios.length;
  }

  
 
  
  Future<void> loadConvenios(context, empresa,dataIni,dataFim) async {
    List<FaturamentoConvenio> convenios = [];
    _convenios.clear();
    convenios.clear();
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
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/FaturamentoEmpresas/$empresa/$dataIni/$dataFim'),
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
      for (var data in data) {
        convenios.add(
          FaturamentoConvenio(
            empresa: data['principal']['empresa'],
            convenio: data['principal']['convenio'],            
            // valor: data['principal']['valor'] == null
            //     ? 0.0
            //     : data['principal']['valor'].toDouble(), 
            valorReal: data['principal']['valor'], 
            ranking:  data['principal']['ranking'],             
          ),
        );
      }
    }
   
    _convenios = convenios.toList();
   

    notifyListeners();
  }

  

}
