// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:pedidocompra/services/navigator_service.dart';

class ConnectZapService with ChangeNotifier {
  final String _token;
  // final String _celular;
  Map<String, dynamic> data = {};

  ConnectZapService(this._token);

  // Função para Enviar Mensagem pelo Whatsapp
  Future<dynamic> enviarWhatsapp(context, celular) async {
    final response = await http.post(
        Uri.parse('https://api.connectzap.com.br/sistema/sendText'),
        body: {
          "SessionName": "EYZZLS03YENJUKGSLYMV",
          "phonefull": "55$celular",
          "msg": "Teste Via AppBiosat"
        });

    if (response.statusCode == 500) {
      data = jsonDecode(response.body);

      if (data['errorMessage'] == 'Não existem dados para serem apresentados') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'ATENÇÃO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Mensagem não enviada, por favor confirme o número do celular.',
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

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'OK!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Mensagem enviada com sucesso !!',
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
  }
}
