import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedidocompra/components/userImagePicker.dart';
import 'package:pedidocompra/exceptions/auth_exception.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:provider/provider.dart';
import '../models/authFormData.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

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
  AuthMode _authMode = AuthMode.login;
  bool _isLogin() => _authMode == AuthMode.login;
  //bool _isSignup() => _authMode == AuthMode.signup;
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();
  bool _isLoading = false;
  final Map<String, String> _authData = {
    'usuario': '',
    'senha': '',
  };

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['usuario']!,
          _authData['senha']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }
  // Future<void> _tokenRest() async {
  //   String nome = _controladorNome.text;
  //   String senha = _controladorSenha.text;

  //   var response = await http.post(
  //       Uri.parse(
  //           'http://192.168.1.5:8084/REST/api/oauth2/v1/token?grant_type=password&username=$nome&password=$senha'),
  //       headers: {
  //         'Authorizathion': 'Bearer <access_token>',
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       });

  //   if (response.statusCode >= 200 && response.statusCode <= 299) {
  //     var jsonResponse = json.decode(response.body);
  //     var _token = jsonResponse['access_token'];

  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (ctx) {
  //         return const PedidosPendentesAprovacao();
  //       }),
  //     );

  //   } else if (response.statusCode >= 400 && response.statusCode <= 499) {
  //     _showDialog400();
  //   } else {
  //     _showDialogX();
  //   }
  // }

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
              const SizedBox(
                height: 50,
                child: Text(
                  'Entre com seu login de usuário e senha do sistema Protheus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                onSaved: (usuario) => _authData['usuario'] = usuario ?? '',
                // validator: (_usuarioProtheus) {
                //   final email = _ ?? '';
                //   if (!email.contains('@')) {
                //     return 'E-mail informado não é válido.';
                //   }
                // },
              ),
              TextFormField(
                controller: _controladorSenha,
                key: const ValueKey('senha'),
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                onSaved: (senha) => _authData['senha'] = senha ?? '',
                // validator: (_password) {
                //   final password = _password ?? '';
                //   if (password.length < 6) {
                //     return 'A senha deve ter pelo menos 6 caracteres.';
                //   }
                // },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _submit,
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
              // TextButton(
              //   onPressed: () {
              //     setState(() {
              //       _formData.toogleAuthMode();
              //     });
              //   },
              //   child: Text(_formData.isLogin
              //       ? 'Cadastrar usuário ?'
              //       : 'Já possui cadastro ?'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
