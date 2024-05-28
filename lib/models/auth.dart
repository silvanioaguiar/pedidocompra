import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pedidocompra/data/store.dart';

class Auth with ChangeNotifier {
  String? _token;
  //String? _refreshToken;
  DateTime? _expiryDate;
  String? _usuario;
  String? _senha;
  String? _empresa;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get senha {
    return _senha;
  }

  String? get usuario {
    return _usuario;
  }

  String? get empresa {
    return _empresa;
  }

  void _showDialog401(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro 401"),
          content: const Text(
            "Usuário e senha protheus não localizados. Por favor tentar novamente !",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogX(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: const Text(
              "Ocorreu um erro inesperado.Verificar o departamento de TI se o servidor está online."),
          actions: <Widget>[
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _authenticate(String usuario, String senha, context) async {
    final url =
        'http://biosat.dyndns.org:8084/REST/api/oauth2/v1/token?grant_type=password&username=$usuario&password=$senha';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        "accept": "application/json",
        "Accept-Charset": "utf-8",
      },
      body: jsonEncode({
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      _token = body['access_token'];
      //_refreshToken = body['refresh_token'];
      _senha = senha;
      _usuario = usuario;
      _expiryDate = DateTime.now().add(
        Duration(
          //seconds: int.parse(body['expires_in']),
          seconds: body['expires_in'],
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        //'refreshToken': _refreshToken,
        'senha': _senha,
        'usuario': _usuario,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      

      

      _autoLogout();
      notifyListeners();
    } else if (response.statusCode == 401) {
      _showDialog401(context);
    } else {
      _showDialogX(context);
    }
  }

  Future<void> login(String usuario, String senha, context) async {
    return _authenticate(usuario, senha, context);
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    //_refreshToken = userData['refreshToken'];
    _senha = userData['senha'];
    _usuario = userData['usuario'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    //_refreshToken = null;
    _expiryDate = null;
    //_usuario = null; // Teste para deixar o ultimo usuário na tela de login
    _senha = null;
    _empresa = null;

    _clearAutoLogoutTimer();
    Store.remove('userData').then((_) {
     notifyListeners();
    });
    
  }

  void _clearAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
