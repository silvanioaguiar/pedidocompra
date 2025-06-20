// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/viacep.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class ViaCepService with ChangeNotifier {
  final String _token;

  List<ViaCep> _endereco = [];
  Map<String, dynamic> data = {};

  int n = 0;

  List<ViaCep> get endereco => [..._endereco];

  ViaCepService(this._token, this._endereco);

  int get enderecoCount {
    return _endereco.length;
  }

  // Carregar Endereco

  Future<dynamic> loadEndereco(context, cep) async {
    List<ViaCep> endereco = [];
    _endereco.clear();
    endereco.clear();
    //String empresaFilial = '';

    Map<String, dynamic> data = {};

    final response = await http
        .get(Uri.parse('http://viacep.com.br/ws/${cep}/json/'), headers: {
      'Content-Type': 'application/json',
      "accept": "application/json",
      "Accept-Charset": "utf-8",
    });

    if (response.statusCode == 500) {
      data = jsonDecode(response.body);

      if (data['erro'] == 'Não existem dados para serem apresentados') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Cep não localizado.',
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
      if (data['erro'] == 'true') {
        showDialog(          
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Cep não localizado.',
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
      } else {
        endereco.add(
          ViaCep(
            cep: data['cep'],
            logradouro: data['logradouro'],
            complemento: data['complemento'],
            unidade: data['unidade'],
            bairro: data['bairro'],
            localidade: data['localidade'],
            uf: data['uf'],
            estado: data['estado'],
            regiao: data['regiao'],
            ddd: data['ddd'],
          ),
        );
      }
    }

    return endereco;
  }
}
