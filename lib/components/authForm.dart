import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pedidocompra/data/store.dart';
import 'package:pedidocompra/exceptions/auth_exception.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:provider/provider.dart';
import '../models/authFormData.dart';

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
  final AuthMode _authMode = AuthMode.login;
  bool _isLogin() => _authMode == AuthMode.login;
  //bool _isSignup() => _authMode == AuthMode.signup;
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();
  String? _userLog;
  String? _passwordLog;
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'usuario': '',
    'senha': '',
  };

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
    Store.saveMap('userLogin', {
      'senha': _controladorSenha.text,
      'usuario': _controladorNome.text,
    });

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
          context,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(
          'Ocorreu um erro inesperado.Verificar com o departamento de TI se o servidor está online.');
    }

    setState(() => _isLoading = false);
  }

  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  @override
  void initState() {
    _loginData();

    super.initState();
  }

  Future<void> _loginData() async {
    final userLogin = await Store.getMap('userLogin');
    if (userLogin.isEmpty) return;

    _passwordLog = userLogin['senha'];
    _userLog = userLogin['usuario'];

    _controladorNome.text = _userLog as String;
    _controladorSenha.text = _passwordLog as String;
  }

  bool _passwordInVisible = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;
    double? heightScreen = 0;
    double? sizeText = 0;

    if (size.width >= 600) {
      widthScreen = 400;
      heightScreen = 300;
      sizeText = 18;
    } else {
      widthScreen = size.width * 0.8;
      heightScreen = size.height * 0.4;
      sizeText = 16;
    }

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            height: heightScreen,
            width: widthScreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: Text(
                    'Entre com seu login de usuário e senha do sistema Protheus',
                    style: TextStyle(
                      fontSize: sizeText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _controladorNome,
                  //initialValue: 'silvanio.junior',
                  key: const ValueKey('usuario'),
                  decoration: const InputDecoration(labelText: 'Usuário'),
                  onSaved: (usuario) => _authData['usuario'] = usuario ?? '',
                ),
                TextFormField(
                  controller: _controladorSenha,
                  key: const ValueKey('senha'),
                  //initialValue: _passwordLog,
                  obscureText: _passwordInVisible,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordInVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordInVisible = !_passwordInVisible;
                        });
                      },
                    ),
                  ),
                  onSaved: (senha) => _authData['senha'] = senha ?? '',
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _submit,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
