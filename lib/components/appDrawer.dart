import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameUser = Provider.of<Auth>(context, listen: false);

    var usuario = nameUser.usuario;

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 2, 33, 59),
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color.fromARGB(255, 252, 164, 0),
            title: Text('Bem vindo $usuario!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business_rounded,color: Colors.white,),
            title: const Text(
              'Empresas - Compras',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.menuEmpresas,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.view_module,color: Colors.white,),
            title: const Text(
              'Módulos',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.menuModulos,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.attach_money,color: Colors.white,),
            title: const Text(
              'Faturamento',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.faturamentoEmpresas,
              );
            },
          ),
          const Divider(),
           ListTile(
            leading: const Icon(Icons.handshake,color: Colors.white,),
            title: const Text(
              'CRM',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.menuCrm,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app,color: Colors.white,),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              //Navigator.of(context).pop();
              // SystemNavigator.pop();
              Provider.of<Auth>(context, listen: false).logout();
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
