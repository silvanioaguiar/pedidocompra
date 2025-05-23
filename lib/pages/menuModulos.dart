import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/pages/crm/crmPage.dart';
import 'package:pedidocompra/pages/crm/menuCrm.dart';
import 'package:pedidocompra/pages/moduloCompras/menuEmpresas.dart';
import 'package:pedidocompra/pages/moduloFaturamento/faturamentoEmpresas.dart';

class MenuModulos extends StatefulWidget {
  const MenuModulos({super.key});

  @override
  State<MenuModulos> createState() => _MenuEmpresasState();
}

class _MenuEmpresasState extends State<MenuModulos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Selecione um Módulo",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fundoTelaPrincipalBiosat3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset('assets/images/logo_Biosat.png'),
                ),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return const MenuEmpresas();
                                  }),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart),
                              iconSize: 100,
                              color: const Color.fromARGB(255, 187, 31, 31),
                            ),
                            const Text(
                              "Compras",
                              style: TextStyle(
                                color: Color.fromARGB(255, 8, 54, 75),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),

                      // Expanded(
                      //   child: Column(
                      //     children: [
                      //       IconButton(
                      //         onPressed: () {
                      //           Navigator.of(context).push(
                      //             MaterialPageRoute(builder: (ctx) {
                      //               //return const MenuEmpresasFat();
                      //               return const FaturamentoEmpresasPage();
                      //             }),
                      //           );
                      //         },
                      //         icon: const Icon(Icons.attach_money_sharp),
                      //         iconSize: 100,
                      //         color: const Color.fromARGB(255, 5, 58, 36),
                      //       ),
                      //       const Text(
                      //         "Faturamento",
                      //         style: TextStyle(
                      //           color: Color.fromARGB(255, 5, 58, 36),
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    //return const MenuEmpresasFat();
                                    return const MenuCrm();
                                  }),
                                );
                              },
                              icon: const Icon(Icons.handshake_sharp),
                              iconSize: 100,
                              color: const Color.fromARGB(255, 6, 5, 58),
                            ),
                            const Text(
                              "CRM",
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 5, 58),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
