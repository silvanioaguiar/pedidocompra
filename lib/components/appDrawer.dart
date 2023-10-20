import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';



class AppDrawer extends StatelessWidget {
  
  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameUser = Provider.of<Auth>(context, listen: false);

    var usuario = nameUser.usuario;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title:  Text('Bem vindo ${usuario}!'),            
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.start_rounded),
            title: const Text('Menu Empresas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.menuEmpresas,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              //Navigator.of(context).pop();
              // SystemNavigator.pop();
              Provider.of<Auth>(context,listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
          
        ],
      ),
    );
  }
}