import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/main.dart';
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
        backgroundColor: azulRoyalTopo,
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
              image: AssetImage('assets/images/FUNDO_BIOSAT_APP_640.jpg'),
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
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return const MenuEmpresas();
                                  }),
                                );
                              },
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                  'assets/images/icone_Compras_02.png',
                                ),
                              ),
                            ),
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
                              GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return const MenuCrm();
                                  }),
                                );
                              },
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                  'assets/images/icone_Crm_02.png',
                                ),
                              ),
                            ),
                            
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
