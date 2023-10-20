import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/models/itens_pedidos.dart';
import 'package:pedidocompra/models/itensPedidosLista.dart';
import 'package:pedidocompra/models/pedidos.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:pedidocompra/pages/authOrHomePage.dart';
import 'package:pedidocompra/pages/authPage.dart';
import 'package:flutter/material.dart';
import 'package:pedidocompra/pages/detalhesPedido.dart';
import 'package:pedidocompra/pages/itensPedido.dart';
import 'package:pedidocompra/pages/menuEmpresas.dart';
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
        ChangeNotifierProvider(
          create: (_) => ItensPedidos(
            empresa: '',
            pedido: '',
            fornecedor: '',
            valor: 0,
            condicaoPagamento: '',
            codProduto: '',
            nomeProduto: '',
            quantidade: 0,
            unidadeMedida: '',
            precoUnitario: 0,
            precoTotal: 0,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, PedidosLista>(
          create: (_) => PedidosLista('', [], '', []),
          update: (ctx, auth, previous) {
            return PedidosLista(
              auth.token ?? '',
              previous?.pedidos ?? [],
              auth.senha ?? '',
              previous?.itensDoPedido ?? [],
            );
          },
        ),
        // ChangeNotifierProvider(
        //   create: (_) => Pedidos(empresa: '', pedido: '', fornecedor: '', valor: 0, condicaoPagamento: ''),
        // ),
        //  ChangeNotifierProvider(
        //   create: (_) => ItensPedidos(codProduto: '',condicaoPagamento: '',empresa: '',fornecedor: '',nomeProduto:'',pedido:'',precoTotal: 0,precoUnitario: 0,quantidade: 0,valor: 0  ),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 30, 52),
          useMaterial3: true,
        ),

        // home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          //AppRoutes.home: (ctx) => const HomePage(),
          AppRoutes.authPage: (ctx) => const AuthPage(),
          AppRoutes.pedidosPendentes: (ctx) =>
              PedidosPendentesAprovacao(empresa: ''),
          AppRoutes.menuEmpresas: (ctx) => const MenuEmpresas(),
          AppRoutes.detalhesPedido: (ctx) => DetalhesPedido(
                empresa: '',
                pedido: '',
              ),
          AppRoutes.itensPedido: (ctx) => ItensPedido(itensPedido: []),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
