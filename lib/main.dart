import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_convenioLista.dart';
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:pedidocompra/models/moduloComprasModels/pedidosLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_localDeEntregaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_notasDoDiaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_notasDoPeriodoLista.dart';
import 'package:pedidocompra/pages/moduloFaturamento/FatLocalDeEntrega.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fatNotasDoDia.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fatNotasDoPeriodo.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fat_graficos.dart/fat_grafico.dart';
import 'package:pedidocompra/pages/moduloFaturamento/faturamentoEmpresas.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoConvenio.dart';
import 'package:pedidocompra/pages/authOrHomePage.dart';
import 'package:pedidocompra/pages/authPage.dart';
import 'package:flutter/material.dart';
import 'package:pedidocompra/pages/moduloCompras/detalhesPedido.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoRepresentante.dart';
import 'package:pedidocompra/pages/moduloCompras/itensPedido.dart';
import 'package:pedidocompra/pages/moduloCompras/menuEmpresas.dart';
import 'package:pedidocompra/pages/moduloFaturamento/menuEmpresasFat.dart';
import 'package:pedidocompra/pages/menuModulos.dart';
import 'package:pedidocompra/pages/moduloCompras/pedidosPendentes.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/moduloFaturamentoModels/fat_empresaLista.dart';

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
            valor: '0',
            condicaoPagamento: '',
            sc: '',
            solicitante: '',
            dataSC: '',
            aprovadorDaSC: '',
            dataAprovacaoSC: '',
            comprador: '',
            codProduto: '',
            nomeProduto: '',
            quantidade: 0,
            unidadeMedida: '',
            precoUnitario: '0',
            precoTotal: '0',
            status: '',
          ),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => FaturamentoConvenio(
        //     empresa: '',
        //     convenio: '',
        //     valor: 0,
        //   ),
        // ),
        ChangeNotifierProxyProvider<Auth, FatConvenioLista>(
          create: (_) => FatConvenioLista('', []),
          update: (ctx, auth, previous) {
            return FatConvenioLista(
              auth.token ?? '',
              previous?.convenios ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, FatNotasDoPeriodoLista>(
          create: (_) => FatNotasDoPeriodoLista('', []),
          update: (ctx, auth, previous) {
            return FatNotasDoPeriodoLista(
              auth.token ?? '',
              previous?.notaFiscal ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, FatNotasDoDiaLista>(
          create: (_) => FatNotasDoDiaLista('', []),
          update: (ctx, auth, previous) {
            return FatNotasDoDiaLista(
              auth.token ?? '',
              previous?.notaFiscal ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, FatLocalDeEntregaLista>(
          create: (_) => FatLocalDeEntregaLista('', []),
          update: (ctx, auth, previous) {
            return FatLocalDeEntregaLista(
              auth.token ?? '',
              previous?.localDeEntrega ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, FatEmpresaLista>(
          create: (_) => FatEmpresaLista('', []),
          update: (ctx, auth, previous) {
            return FatEmpresaLista(
              auth.token ?? '',
              previous?.empresas ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, PedidosLista>(
          create: (_) => PedidosLista('', [], []),
          update: (ctx, auth, previous) {
            return PedidosLista(
              auth.token ?? '',
              previous?.pedidos ?? [],
              //auth.senha ?? '',
              previous?.itensDoPedido ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pt')],
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 30, 52),
          useMaterial3: true,
        ),
        navigatorKey: NavigatorService.instance.key,
        // home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.authPage: (ctx) => const AuthPage(),
          AppRoutes.pedidosPendentes: (ctx) =>
              PedidosPendentesAprovacao(empresa: ''),
          AppRoutes.menuModulos: (ctx) => const MenuModulos(),
          AppRoutes.menuEmpresas: (ctx) => const MenuEmpresas(),
          AppRoutes.menuEmpresasFat: (ctx) => const MenuEmpresasFat(),
          AppRoutes.detalhesPedido: (ctx) => DetalhesPedido(
                empresa: '',
                pedido: '',
              ),
          AppRoutes.itensPedido: (ctx) => ItensPedido(itensPedido: const []),
          AppRoutes.faturamentoEmpresas: (ctx) =>
              const FaturamentoEmpresasPage(),
          AppRoutes.fatLocalDeEntrega: (ctx) => FatLocalDeEntrega(
                empresa: '',
                dateIni: DateTime.now(),
                dateFim: DateTime.now(),
              ),
          AppRoutes.fatNotasDoPeriodo: (ctx) => FatNotasDoPeriodo(
                empresa: '',
                dateIni: DateTime.now(),
                dateFim: DateTime.now(),
              ),
          AppRoutes.fatNotasDoDia: (ctx) => FatNotasDoDia(
                empresa: '',
                dateIni: DateTime.now(),
                dateFim: DateTime.now(),
                valorDiaFormatado: '',
              ),
          AppRoutes.graficoRepresentante: (ctx) => GraficoRepresentantePage(),
          AppRoutes.graficoConvenio: (ctx) => GraficoConvenio(empresa: ''),
          AppRoutes.fatGrafico: (ctx) => LineChartWidget(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
