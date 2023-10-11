import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedidocompra/components/userImagePicker.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:provider/provider.dart';
import '../models/authFormData.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showDialog400() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro 400"),
          content: const Text("Usuário não cadastrado"),
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

  void _showDialogX() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: const Text("Servidor fora de serviço"),
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

  Future<void> _tokenRest() async {
    String nome = _controladorNome.text;
    String senha = _controladorSenha.text;

    var response = await http.post(
        Uri.parse(
            'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=$nome&password=$senha'),
        headers: {
          'Authorizathion': 'Bearer <access_token>',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonResponse = json.decode(response.body);
      var _token = jsonResponse['access_token'];

      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) {
          return  PedidosPendentesAprovacao();
        }),
      );
      
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      _showDialog400();
    } else {
      _showDialogX();
    }
  }

  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignup)
                UserImagePicker(onImagePick: _handleImagePick),
              TextFormField(
                controller: _controladorNome,
                // key: const ValueKey('email'),
                // decoration: const InputDecoration(labelText: 'E-mail'),
                // validator: (_email) {
                //   final email = _email ?? '';
                //   if (!email.contains('@')) {
                //     return 'E-mail informado não é válido.';
                //   }
                // },
                key: const ValueKey('usuario'),
                decoration: const InputDecoration(labelText: 'Usuário'),
                // validator: (_usuarioProtheus) {
                //   final email = _ ?? '';
                //   if (!email.contains('@')) {
                //     return 'E-mail informado não é válido.';
                //   }
                // },
              ),
              TextFormField(
                controller: _controladorSenha,
                key: const ValueKey('password'),
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                // validator: (_password) {
                //   final password = _password ?? '';
                //   if (password.length < 6) {
                //     return 'A senha deve ter pelo menos 6 caracteres.';
                //   }
                // },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _tokenRest,
                // onPressed: () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(builder: (ctx) {
                //       return const PedidosPendentesAprovacao();
                //     }),
                //   );
                // },
                style: _formData.isLogin
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700)
                    : ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                child: Text(
                  _formData.isLogin ? 'Entrar' : 'Cadastrar',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formData.toogleAuthMode();
                  });
                },
                child: Text(_formData.isLogin
                    ? 'Cadastrar usuário ?'
                    : 'Já possui cadastro ?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
