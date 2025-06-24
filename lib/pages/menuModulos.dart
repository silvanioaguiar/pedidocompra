import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/pages/crm/menuCrm.dart';
import 'package:pedidocompra/pages/moduloCompras/menuEmpresas.dart';
import 'package:pedidocompra/providers/acessoApp.dart';
import 'package:provider/provider.dart';

class MenuModulos extends StatefulWidget {
  const MenuModulos({super.key});

  @override
  State<MenuModulos> createState() => _MenuModulosState();
}

class _MenuModulosState extends State<MenuModulos> {
  bool _isLoading = true;
  bool _temAcessoCompras = false;
  bool _temAcessoCrm = false;

  List acessos = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AcessoApp>(
      context,
      listen: false,
    ).loadAcessos(context).then((value) {
      setState(() {
        _temAcessoCompras =
            value.isNotEmpty && value[0].acessoCompras == "Acesso Permitido";
        _temAcessoCrm =
            value.isNotEmpty && value[0].acessoCrm == "Acesso Permitido";

        _isLoading = false;
      });
    });   
  }

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
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/fundos/FUNDO_BIOSAT_APP_640.jpg'),
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
                        child: Image.asset(
                            'assets/images/logos/Logo_Biosat_PaginaInicial_02.png'),
                      ),
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_temAcessoCompras)
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
                                          'assets/images/botoes/icone_Compras_02.png',
                                          scale: 1.5,
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
                            if (_temAcessoCrm)
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
                                          'assets/images/botoes/icone_Crm_02.png',
                                          scale: 1.5,
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
