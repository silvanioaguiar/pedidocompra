// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class MedicosLista with ChangeNotifier {
  final String _token;

  List<Medicos> _medicos = [];
  List<dynamic> data = [];
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<Medicos> get medicos => [..._medicos];

  MedicosLista(this._token, this._medicos);

  int get visitasCount {
    return _medicos.length;
  }

  // Carregar Medicos

  Future<dynamic> loadMedicos(context) async {
    String jsonString = '';
    List<Medicos> medicos = [];
    _medicos.clear();
    medicos.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ListaMedicos'),
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
              'Nenhum medico registrado.',
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
        medicos.add(
          Medicos(
            codigo: data['principal']['codigo'],
            nomeMedico: data['principal']['nomeMedico'],
            representante: data['principal']['representante'],
            crm: data['principal']['crm'],
            tipoLocal: data['principal']['tipoLocal'],
            localDeVisita: data['principal']['localDeVisita'],
            enderecoVisita: data['principal']['enderecoVisita'],
            numeroEnderecoVisita: data['principal']['numeroEnderecoVisita'],
            especialidade: data['principal']['especialidade'],
            cep: data['principal']['cep'],
            estado: data['principal']['estado'],
            municipio: data['principal']['municipio'],
            bairro: data['principal']['bairro'],
            contato: data['principal']['contato'],
            ddd: data['principal']['ddd'],
            telefone: data['principal']['telefone'],
            email: data['principal']['email'],
          ),
        );
      }
    }

    _medicos = medicos;

    notifyListeners();
    return _medicos;
  }


  Future<dynamic> incluirMedico(context, dadosMedico) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/IncluirMedico');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({       
      'nomeMedico': dadosMedico['nomeMedico'],
      'especialidade': dadosMedico['especialidade'],
      'endereco': dadosMedico['endereco'],
      'numeroEndereco': dadosMedico['numeroEndereco'],
      'municipio': dadosMedico['municipio'],
      'estado': dadosMedico['estado'],
      'bairro': dadosMedico['bairro'],
      'cep': dadosMedico['cep'],
      'ddd': dadosMedico['ddd'],
      'telefone': dadosMedico['telefone'],
      'contato': dadosMedico['contato'],
      'email': dadosMedico['email'],
      'crm': dadosMedico['crm'],
      'tipoLocal': dadosMedico['tipoLocal'],
      'nomeLocal': dadosMedico['nomeLocal'],
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
            'Não foi possivel incluir o médico. Contate o administrador do sistema',
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
            'Médico incluído com sucesso',
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
    await loadMedicos(context);
  }

  Future<dynamic> editarMedico(context, dadosMedico) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EditarMedico');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({    
      'codigo': dadosMedico['codigo'],   
      'nomeMedico': dadosMedico['nomeMedico'],
      'especialidade': dadosMedico['especialidade'],
      'endereco': dadosMedico['endereco'],
      'numeroEndereco': dadosMedico['numeroEndereco'],
      'municipio': dadosMedico['municipio'],
      'estado': dadosMedico['estado'],
      'bairro': dadosMedico['bairro'],
      'cep': dadosMedico['cep'],
      'ddd': dadosMedico['ddd'],
      'telefone': dadosMedico['telefone'],
      'contato': dadosMedico['contato'],
      'email': dadosMedico['email'],
      'crm': dadosMedico['crm'],
      'tipoLocal': dadosMedico['tipoLocal'],
      'nomeLocal': dadosMedico['nomeLocal'],
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
            'Não foi possivel editar o médico. Contate o administrador do sistema',
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
            'Médico alterado com sucesso',
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
    await loadMedicos(context);
  }


  Future<dynamic> bloquearMedico(context, codigoMedico) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/BloquearMedico');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({    
      'codigo': codigoMedico,   
      
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
            'Não foi possivel bloquear o médico. Contate o administrador do sistema',
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
            'Médico bloqueado com sucesso',
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
    await loadMedicos(context);
  }
}
