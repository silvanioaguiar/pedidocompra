import 'package:pedidocompra/models/auth.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:pedidocompra/pages/authOrHomePage.dart';
import 'package:pedidocompra/pages/authPage.dart';
import 'package:flutter/material.dart';
import 'package:pedidocompra/pages/homepage.dart';
import 'package:pedidocompra/pages/menuEmpresas.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';
import 'package:pedidocompra/routes/appRoutes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primaryColor: const Color.fromARGB(255, 0, 30, 52),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Biosat'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text(widget.title,
//             style: TextStyle(
//               color: Theme.of(context).secondaryHeaderColor,
//             )),
//       ),
//       body: Center(
//         child: Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/fundoTelaPrincipalBiosat3.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 width: 250,
//                 height: 100,
//                 child: Image.asset('assets/images/logo_Biosat.png'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (ctx) {
//                       return AuthPage();
//                     }),
//                   );
//                 },
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(Theme.of(context).primaryColor),
//                   minimumSize: MaterialStateProperty.all(const Size(200, 40)),
//                   foregroundColor: MaterialStateProperty.all(
//                       Theme.of(context).secondaryHeaderColor),
//                 ),
//                 child: const Text('Iniciar'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, PedidosLista>(
          create: (_) => PedidosLista('', [], '', ''),
          update: (ctx, auth, previous) {
            return PedidosLista(
              auth.token ?? '',
              previous?.pedidos ?? [],
              auth.senha ?? '',
              auth.empresa ?? '',
            );
          },
        ),
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
          AppRoutes.home: (ctx) => const HomePage(),
          AppRoutes.authPage: (ctx) => const AuthPage(),
          AppRoutes.pedidosPendentes: (ctx) =>
              PedidosPendentesAprovacao(),
          AppRoutes.menuEmpresas: (ctx) => const MenuEmpresas(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
