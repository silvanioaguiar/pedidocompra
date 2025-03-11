// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class VisitasLista with ChangeNotifier {
  final String _token;

  List<Visitas> _visitas = [];
  List<dynamic> data = [];
  List<dynamic> data2 = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Visitas> get visitas => [..._visitas];

  VisitasLista(this._token, this._visitas);

  int get visitasCount {
    return _visitas.length;
  }

  // Carregar Visitas

  Future<dynamic> loadVisitas(context) async {
    List<Visitas> visitas = [];
    _visitas.clear();
    visitas.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    // if (empresa == 'Libertad') {
    //   empresaFilial = '01,01';
    // } else if (empresa == 'Biosat Matriz Fabrica') {
    //   empresaFilial = '02,01';
    // } else if (empresa == 'Biosat Filial') {
    //   empresaFilial = '02,02';
    // } else if (empresa == 'Big Assistencia Tecnica') {
    //   empresaFilial = '05,01';
    // } else if (empresa == 'Big Locacao') {
    //   empresaFilial = '05,02';
    // } else if (empresa == 'E-med') {
    //   empresaFilial = '06,01';
    // } else if (empresa == 'Brumed') {
    //   empresaFilial = '08,01';
    // }

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas'),
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
              'Nenhuma visita registrada.',
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
    } else {
      data = jsonDecode(response.body);
      utf8.decode(response.bodyBytes);
      data.asMap();
      for (var data in data) {
        visitas.add(
          Visitas(
              codigo: data['principal']['codigo'],
              status: data['principal']['status'],
              codigoRepresentante: data['principal']['codigoRepresentante'],
              nomeRepresentante: data['principal']['nomeRepresentante'],
              codigoMedico: data['principal']['codigoMedico'],
              nomeMedico: data['principal']['nomeMedico'],
              local: data['principal']['local'],
              dataPrevista: DateTime.parse(data['principal']['dataPrevista']),
              horaPrevista: data['principal']['horaPrevista'],
              dataRealizada: data['principal']['dataRealizada'] != null &&
                      data['principal']['dataRealizada'].trim().isNotEmpty
                  ? DateTime.parse(data['principal']['dataRealizada'].trim())
                  : null,
              horaRealizada: data['principal']['horaRealizada'] ?? "00:00"),
        );
      }
    }

    _visitas = visitas.reversed.toList();

    notifyListeners();
  }
}
