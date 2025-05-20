// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/formularioVisita.dart';
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class FormularioVisitaProvider with ChangeNotifier {
  final String _token;

  List<FormularioVisita> _formulario = [];
  List<dynamic> data = [];
  List<dynamic> data2 = [];
  List<Visitas>? loadedVisitas;
  Map<String, dynamic> data0 = {};

  int n = 0;

  List<FormularioVisita> get formulario => [..._formulario];

  FormularioVisitaProvider(this._token, this._formulario);

  Future<dynamic> incluirFormulario(context, dadosFormulario) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/IncluirFormulario');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigoVisita': dadosFormulario['codigoVisita'],
      'codigoMedico': dadosFormulario['codigoMedico'],
      'nomeMedico': dadosFormulario['nomeMedico'],
      'codigoLocal': dadosFormulario['codigoLocal'],
      'nomeLocal': dadosFormulario['nomeLocal'],
      'dataVisita': dadosFormulario['dataVisita'],
      'horaVisita': dadosFormulario['horaVisita'],
      'avaliacao': dadosFormulario['avaliacao'],
      'listaHospitais': dadosFormulario['listaHospitais'],
      'clienteDoGrupo': dadosFormulario['clienteDoGrupo'],
      'listaConcorrentes': dadosFormulario['listaConcorrentes'],
      'especialidade': dadosFormulario['especialidade'],
      'proximosPassos': dadosFormulario['proximosPassos'],
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
            'Não foi possivel  registrar o formulário. Contate o administrador do sistema',
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
            'Formulário registrado com sucesso',
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
  }

  Future<dynamic> getFormulario(context, codigoFormulario) async {

    List<FormularioVisita> formulario = [];
    _formulario.clear();
    formulario.clear();


    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/Formulario/$codigoFormulario');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final response = await http.get(uri, headers: headers);    

    data2 = jsonDecode(response.body);
    utf8.decode(response.bodyBytes);
    data2.asMap();
    for (var data2 in data2) {
      int timestamp = int.parse(data2[ 'principal' ][ 'dataVisita' ].replaceAll(RegExp(r'\D'), ''));
      formulario.add(
        FormularioVisita(
         avaliacao: data2[ 'principal' ][ 'avaliacao' ],
         clienteDoGrupo: data2[ 'principal' ][ 'clienteDoGrupo' ],
         codigoFormulario: data2[ 'principal' ][ 'codigoFormulario' ],
         codigoLocal: data2[ 'principal' ][ 'codigoLocal' ],
         codigoMedico: data2[ 'principal' ][ 'codigoMedico' ],
         codigoVisita: data2[ 'principal' ][ 'codigoVisita' ],
         dataVisita: DateTime.fromMillisecondsSinceEpoch(timestamp),
         especialidade: data2[ 'principal' ][ 'especialidade' ],
         horaVisita: data2[ 'principal' ][ 'horaVisita' ],
         listaConcorrentes: data2[ 'principal' ][ 'listaConcorrentes' ],
         listaHospitais: data2[ 'principal' ][ 'listaHospitais' ],
         nomeLocal: data2[ 'principal' ][ 'nomeLocal' ],
         nomeMedico: data2[ 'principal' ][ 'nomeMedico' ],
         proximosPassos: data2[ 'principal' ][ 'proximosPassos' ],
        ),
      );
    }

    _formulario = formulario.toList();
    notifyListeners();
    return formulario;
  }

  Future<dynamic> editarFormulario(context, dadosFormulario) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EditarFormulario');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigoFormulario': dadosFormulario['codigoFormulario'],
      'codigoVisita': dadosFormulario['codigoVisita'],
      'codigoMedico': dadosFormulario['codigoMedico'],
      'nomeMedico': dadosFormulario['nomeMedico'],
      'codigoLocal': dadosFormulario['codigoLocal'],
      'nomeLocal': dadosFormulario['nomeLocal'],
      'dataVisita': dadosFormulario['dataVisita'],
      'horaVisita': dadosFormulario['horaVisita'],
      'avaliacao': dadosFormulario['avaliacao'],
      'listaHospitais': dadosFormulario['listaHospitais'],
      'clienteDoGrupo': dadosFormulario['clienteDoGrupo'],
      'listaConcorrentes': dadosFormulario['listaConcorrentes'],
      'especialidade': dadosFormulario['especialidade'],
      'proximosPassos': dadosFormulario['proximosPassos'],
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
            'Não foi possivel  alterar o formulário. Contate o administrador do sistema',
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
            'Formulário alterado com sucesso',
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
  }

  Future<dynamic> excluirFormulario(context, codigoFormulario) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ExcluirFormulario/$codigoFormulario');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    // final body = jsonEncode({
    //   'codigoFormulario': dadosFormulario['codigoFormulario'],
    //   'codigoVisita': dadosFormulario['codigoVisita'],
    //   'codigoMedico': dadosFormulario['codigoMedico'],
    //   'nomeMedico': dadosFormulario['nomeMedico'],
    //   'codigoLocal': dadosFormulario['codigoLocal'],
    //   'nomeLocal': dadosFormulario['nomeLocal'],
    //   'dataVisita': dadosFormulario['dataVisita'],
    //   'horaVisita': dadosFormulario['horaVisita'],
    //   'avaliacao': dadosFormulario['avaliacao'],
    //   'listaHospitais': dadosFormulario['listaHospitais'],
    //   'clienteDoGrupo': dadosFormulario['clienteDoGrupo'],
    //   'listaConcorrentes': dadosFormulario['listaConcorrentes'],
    //   'especialidade': dadosFormulario['especialidade'],
    //   'proximosPassos': dadosFormulario['proximosPassos'],
    // });

    final response = await http.post(uri, headers: headers);

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
            'Não foi possivel  excluir o formulário. Contate o administrador do sistema',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Fecha o dialog 2
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
            'Formulário excluído com sucesso',
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
  }


   Future<dynamic> enviarEmailFormulario(context, dadosFormulario, email) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EnviarFormulario');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigoFormulario': dadosFormulario['codigo'],
      'email': email,
     
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
            'Não foi possivel  enviar o formulário. Contate o administrador do sistema',
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
            'Formulário enviado com sucesso',
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
  }
}
