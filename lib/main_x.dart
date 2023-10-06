import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/pages/authPage.dart';
import 'package:flutter/material.dart';
import 'package:pedidocompra/pages/homePage.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        // ChangeNotifierProxyProvider<Auth, PedidosPendentes>(
        //   create: (_) => ProductList('', []),
        //   update: (ctx, auth, previous) {
        //     return ProductList(
        //       auth.token ?? '',
        //       previous?.items ?? [],
        //     );
        //   },
        // ),
       
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        // home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.home: (ctx) => const HomePage(),
          AppRoutes.authPage: (ctx) => const AuthPage(),
          AppRoutes.pedidosPendentes: (ctx) => const PedidosPendentesAprovacao(),
          
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

