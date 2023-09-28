import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pedidocompra/components/userImagePicker.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:pedidocompra/pages/pedidosPendentes_old.dart';
import '../models/authFormData.dart';
import 'package:http/http.dart ' as http;

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

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      return _showError('Imagem não selecionada!');
    }

    widget.onSubmit(_formData);
  }

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
                //onPressed: _submit,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const PedidosPendentesAprovacao();
                    }),
                  );
                },
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
