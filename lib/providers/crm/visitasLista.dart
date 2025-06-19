// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/services/navigator_service.dart';

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
              codigoLocalDeEntrega:
                  data['principal']['codigoLocalDeEntrega'] ?? "",
              local: data['principal']['local'],
              objetivo: data['principal']['objetivo'],
              cancelarMotivo: data['principal']['cancelarMotivo'] ?? "",
              dataPrevista: DateTime.parse(data['principal']['dataPrevista']),
              horaPrevista: data['principal']['horaPrevista'],
              dataRealizada: data['principal']['dataRealizada'] != null &&
                      data['principal']['dataRealizada'].trim().isNotEmpty
                  ? DateTime.parse(data['principal']['dataRealizada'].trim())
                  : null,
              horaRealizada: data['principal']['horaRealizada'] ?? "00:00",
              nomeUsuario: data['principal']['nomeUsuario'] ?? "",
              codFormulario: data['principal']['codFormulario'] ?? ""),
        );
      }
    }

    _visitas = visitas.reversed.toList();

    notifyListeners();
    return visitas;
  }

  Future<dynamic> loadVisitaUnica(context, codigoVisita) async {
    List<Visitas> visitas = [];
    _visitas.clear();
    visitas.clear();
    //String empresaFilial = '';
    Map<String, dynamic> data0 = {};
    data = [];

    final response = await http.get(
        Uri.parse(
            'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/VisitaUnica/$codigoVisita'),
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
              codigoLocalDeEntrega:
                  data['principal']['codigoLocalDeEntrega'] ?? "",
              local: data['principal']['local'],
              objetivo: data['principal']['objetivo'],
              cancelarMotivo: data['principal']['cancelarMotivo'] ?? "",
              dataPrevista: DateTime.parse(data['principal']['dataPrevista']),
              horaPrevista: data['principal']['horaPrevista'],
              dataRealizada: data['principal']['dataRealizada'] != null &&
                      data['principal']['dataRealizada'].trim().isNotEmpty
                  ? DateTime.parse(data['principal']['dataRealizada'].trim())
                  : null,
              horaRealizada: data['principal']['horaRealizada'] ?? "00:00",
              nomeUsuario: data['principal']['nomeUsuario'] ?? "",
              codFormulario: data['principal']['codFormulario'] ?? ""),
        );
      }
    }

    notifyListeners();
    return visitas;
  }

  Future<dynamic> editarVisitas(context, dadosVisita) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/Editar');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigo': dadosVisita['codigo'],
      'medico': dadosVisita['medico'],
      'codigoMedico': dadosVisita['codigoMedico'],
      'localVisita': dadosVisita['local'],
      'objetivo': dadosVisita['objetivo'],
      'dataVisita': dadosVisita['dataPrevista'],
      'horaVisita': dadosVisita['horaPrevista'],
      'statusVisita': dadosVisita['status'],
      'cancelarMotivo':dadosVisita['cancelarMotivo'],
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
            'Não foi possivel editar a visita. Contate o administrador do sistema',
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
            'Visita atualizada com sucesso',
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
    await loadVisitas(context);
    await loadVisitaUnica(context, dadosVisita['codigo']);
  }

  Future<dynamic> incluirVisitas(context, dadosVisita) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/Incluir');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };

    final body = jsonEncode({
      'codigoMedico': dadosVisita['codigoMedico'],
      'medico': dadosVisita['medico'],
      'codigoLocalDeEntrega': dadosVisita['codigoLocalDeEntrega'],
      'localVisita': dadosVisita['localDescricao'],
      'objetivo': dadosVisita['objetivo'],
      'dataVisita': dadosVisita['dataPrevista'],
      'horaVisita': dadosVisita['horaPrevista'],
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
            'Não foi possivel incluir a visita. Contate o administrador do sistema',
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
            'Visita incluída com sucesso',
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
    await loadVisitas(context);
  }

  Future<dynamic> excluirVisita(context, codigoVisita) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/ExcluirVisita/$codigoVisita');
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
            'Não foi possível excluir a visita. Contate o administrador do sistema',
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
            'Visita excluída com sucesso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Fecha o dialog 2
                Navigator.pop(context, true); // Fecha a tela principal
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
    await loadVisitas(context);
  }

  Future<dynamic> enviarEmailRelatorio(context, dadosRelatorio) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EnviarRelatorioVisitas');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };
    List listaRelatorio = dadosRelatorio.toList();

    final body = jsonEncode({
      'tipoRelatorio': listaRelatorio[0],
      'email': listaRelatorio[1],
      'dataInicio': (listaRelatorio[2] as DateTime).toIso8601String(),
      'dataFim': (listaRelatorio[3] as DateTime).toIso8601String(),
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
            'Não foi possivel  enviar o relatório. Contate o administrador do sistema',
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
            'Relatório enviado com sucesso',
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

  Future<dynamic> enviarWhatsappRelatorio(context, dadosRelatorio) async {
    final uri = Uri.parse(
        'http://biosat.dyndns.org:8084/REST/api/biosat/v1/TodasAsVisitas/EnviarWhatsappRelatorioVisitas');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Charset': 'utf-8',
      'tenantId': '02,01', // fixado como Biosat Matriz
      'Authorization': 'Bearer $_token',
    };
    List listaRelatorio = dadosRelatorio.toList();

    final body = jsonEncode({
      'tipoRelatorio': listaRelatorio[0],
      'celular': listaRelatorio[1],
      'dataInicio': (listaRelatorio[2] as DateTime).toIso8601String(),
      'dataFim': (listaRelatorio[3] as DateTime).toIso8601String(),      
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
            'Não foi possivel  enviar o relatório. Contate o administrador do sistema',
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
            'Relatório enviado com sucesso',
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
