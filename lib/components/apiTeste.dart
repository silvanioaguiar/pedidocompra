import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// class ApiTeste extends StatelessWidget {
//    ApiTeste({super.key});

//   String request =
//     "http//192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=SILVANIO.JUNIOR&password=striker20";

//   Future<Map> getData() async {
//     http.Response response = await http.post(request as Uri);
//     return json.decode(response.body);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class ApiTeste extends StatelessWidget {
   ApiTeste({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controladorNome = TextEditingController();
    final TextEditingController _controladorSenha = TextEditingController();

    //final String tokenRest;

    Future<void> _tokenRest() async {
      String nome = _controladorNome.text;
      String senha = _controladorSenha.text;

      var response = await http.post(
          //Uri.parse('http://192.168.1.5:8084/REST/api/oauth2/v1/token'),
          Uri.parse(
              'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=SILVANIO.JUNIOR&password=striker20'), //);
          // Uri.parse(
          //     'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=$nome&password=$senha'),
          //body: jsonEncode(<String>{'access_token'}),
          //body: await jsonDecode(json.encode({'access_token'})),
          headers: {
            'Authorizathion': 'Bearer <access_token>',
            'Content-Type': 'application/json; charset=UTF-8',
          });

      // var response = await http.get(
      //   //Uri.parse('http://192.168.1.5:8084/REST/api/oauth2/v1/token'),
      //   Uri.parse('http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=SILVANIO.JUNIOR&password=striker20'),//);
      //   // Uri.parse(
      //   //     'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=$nome&password=$senha'),
      //   //body: jsonEncode(<String>{'access_token'}),
      //   //body: await jsonDecode(json.encode({'access_token'})),
      //   headers: {
      //     'Authorizathion':
      //     'Bearer <access_token>',
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   }
      // );
      // headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      // },
      //print(response.body);
      print(Utf8Codec().decode(response.bodyBytes));

      // body: jsonEncode(<String, String>{
      //     'access_token':
      //     //'username': ,
      //    // 'password':
      // })
      //);
    }
    return Scaffold(

    );
  }
}
