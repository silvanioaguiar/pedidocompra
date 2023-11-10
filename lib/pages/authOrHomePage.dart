import 'package:flutter/material.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/pages/authPage.dart';
import 'package:pedidocompra/pages/menuEmpresas.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:provider/provider.dart';


class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    //return auth.isAuth ? const PedidosPendentesAprovacao() : const AuthPage();
    //return auth.isAuth ? const MenuEmpresas() : const AuthPage();
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const MenuEmpresas() : const AuthPage();
        }
      },
    );
  }
}