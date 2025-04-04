import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/providers/crm/HospitaisLista.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/providers/crm/formularioVisitaProvider.dart';
import 'package:pedidocompra/providers/crm/locaisDeEntregaLista.dart';
import 'package:pedidocompra/providers/crm/medicosLista.dart';
import 'package:pedidocompra/providers/crm/representantesLista.dart';
import 'package:pedidocompra/services/viacep_service.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:pedidocompra/providers/faturamento/fat_convenioLista.dart';
import 'package:pedidocompra/models/moduloComprasModels/itens_pedidos.dart';
import 'package:pedidocompra/providers/compras/pedidosLista.dart';
import 'package:pedidocompra/providers/faturamento/fat_localDeEntregaLista.dart';
import 'package:pedidocompra/providers/faturamento/fat_notasDoDiaLista.dart';
import 'package:pedidocompra/providers/faturamento/fat_notasDoPeriodoLista.dart';
import 'package:pedidocompra/pages/crm/clientesCrm.dart';
import 'package:pedidocompra/pages/crm/concorrentesCrm.dart';
import 'package:pedidocompra/pages/crm/editarAgendaCrm.dart';
import 'package:pedidocompra/pages/crm/faturamentoCrm.dart';
import 'package:pedidocompra/pages/crm/formularioCrm.dart';
import 'package:pedidocompra/pages/crm/formularioVisitaCrm.dart';
import 'package:pedidocompra/pages/crm/incluirAgendaCrm.dart';
import 'package:pedidocompra/pages/crm/incluirConcorrenteCrm.dart';
import 'package:pedidocompra/pages/crm/menuCrm.dart';
import 'package:pedidocompra/pages/crm/prospectCrm.dart';
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

import 'providers/faturamento/fat_empresaLista.dart';

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
        ChangeNotifierProxyProvider<Auth, VisitasLista>(
          create: (_) => VisitasLista('', []),
          update: (ctx, auth, previous) {
            return VisitasLista(
              auth.token ?? '',
              previous?.visitas ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, MedicosLista>(
          create: (_) => MedicosLista('', []),
          update: (ctx, auth, previous) {
            return MedicosLista(
              auth.token ?? '',
              previous?.medicos ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, RepresentantesLista>(
          create: (_) => RepresentantesLista('', []),
          update: (ctx, auth, previous) {
            return RepresentantesLista(
              auth.token ?? '',
              previous?.representantes ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, LocaisDeEntregaLista>(
          create: (_) => LocaisDeEntregaLista('', []),
          update: (ctx, auth, previous) {
            return LocaisDeEntregaLista(
              auth.token ?? '',
              previous?.locaisDeEntrega ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ConcorrentesLista>(
          create: (_) => ConcorrentesLista('', []),
          update: (ctx, auth, previous) {
            return ConcorrentesLista(
              auth.token ?? '',
              previous?.concorrentes ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, HospitaisLista>(
          create: (_) => HospitaisLista('', []),
          update: (ctx, auth, previous) {
            return HospitaisLista(
              auth.token ?? '',
              previous?.hospitais ?? [],
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ViaCepService>(
          create: (_) => ViaCepService('', []),
          update: (ctx, auth, previous) {
            return ViaCepService(
              auth.token ?? '',
              previous?.endereco ?? [],
              
              //auth.senha ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, FormularioVisitaProvider>(
          create: (_) => FormularioVisitaProvider('', []),
          update: (ctx, auth, previous) {
            return FormularioVisitaProvider(
              auth.token ?? '',
              previous?.formulario ?? [],
              
              //auth.senha ?? '',
            );
          },
        ),
      ],
      child: MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pt')],
        title: 'App Biosat',
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
              const PedidosPendentesAprovacao(empresa: ''),
          AppRoutes.menuModulos: (ctx) => const MenuModulos(),
          AppRoutes.menuEmpresas: (ctx) => const MenuEmpresas(),
          AppRoutes.menuEmpresasFat: (ctx) => const MenuEmpresasFat(),
          AppRoutes.detalhesPedido: (ctx) => const DetalhesPedido(
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
          AppRoutes.graficoRepresentante: (ctx) => const GraficoRepresentantePage(),
          AppRoutes.graficoConvenio: (ctx) => const GraficoConvenio(empresa: ''),
          AppRoutes.fatGrafico: (ctx) => const LineChartWidget(),
          AppRoutes.menuCrm: (ctx) => const MenuCrm(),
          AppRoutes.clientesCrm: (ctx) => const ClientesCrm(),
          AppRoutes.concorrentesCrm: (ctx) => const ConcorrentesCrm(),
          AppRoutes.prospectCrm: (ctx) => const ProspectCrm(),
          AppRoutes.faturamentoCrm: (ctx) => const FaturamentoCrm(),
          AppRoutes.formularioCrm: (ctx) => const FormularioCrm(),
          AppRoutes.incluirAgendaCrm: (ctx) => const IncluirAgendaCrm(),
          AppRoutes.incluirConcorrenteCrm: (ctx) => IncluirConcorrenteCrm(),
          AppRoutes.editarAgendaCrm: (ctx) => EditarAgendaCrm(
                  event: Event(
                codigo: "",
                codigoMedico: "",
                nomeMedico: "",
                codigoRepresentante: "",
                nomeRepresentante: "",
                codigoLocalDeEntrega: "",
                local: "",
                status: "",
                dataPrevista: DateTime.now(),
                dataRealizada: DateTime.now(),
                horaPrevista: "",
                horaRealizada: "",
                nomeUsuario: "",
              )),
          AppRoutes.formularioVisitaCrm: (ctx) => FormularioVisitaCrm(
                event: Event(
                  codigo: "",
                  codigoMedico: "",
                  nomeMedico: "",
                  codigoRepresentante: "",
                  nomeRepresentante: "",
                  codigoLocalDeEntrega: "",
                  local: "",
                  status: "",
                  dataPrevista: DateTime.now(),
                  dataRealizada: DateTime.now(),
                  horaPrevista: "",
                  horaRealizada: "",
                  nomeUsuario: "",
                ),
              ),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
