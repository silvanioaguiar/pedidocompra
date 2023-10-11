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
    return auth.isAuth ? const MenuEmpresas() : const AuthPage();
  }
}