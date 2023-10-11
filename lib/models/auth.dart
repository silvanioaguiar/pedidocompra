import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _senha;
  String? _empresa;

  
 

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }
    String? get senha {
    return  _senha ;
  }

    String? get empresa {
    return  _empresa ;
  }


  //  void _showDialog400() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Erro 400"),
  //         content: const Text("Usuário não cadastrado"),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Fechar"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showDialogX() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Erro"),
  //         content: const Text("Servidor fora de serviço"),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Fechar"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  Future<void> _authenticate(String usuario, String senha) async {

    final url =
        'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=$usuario&password=$senha';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      _token = body['access_token'];
      _senha = senha;
      _expiryDate = DateTime.now().add(
        Duration(
          //seconds: int.parse(body['expires_in']),
          seconds: body['expires_in'],
        ),
      );

      notifyListeners();
      
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {     
      //_showDialog400();
    } else {
     // _showDialogX();
    }
  }

  Future<void> login(String usuario, String senha) async {
    return _authenticate(usuario, senha);
  }
}
