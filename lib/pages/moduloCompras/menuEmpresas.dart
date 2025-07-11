import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/pages/moduloCompras/pedidosPendentes.dart';

class MenuEmpresas extends StatefulWidget {
  const MenuEmpresas({super.key});

  @override
  State<MenuEmpresas> createState() => _MenuEmpresasState();
}

class _MenuEmpresasState extends State<MenuEmpresas> {
  final String _bigAt = "Big Assistencia Tecnica";
  final String _bigLoc = "Big Locacao";
  final String _biosatMatriz = 'Biosat Matriz Fabrica';
  final String _biosatFilial = 'Biosat Filial';
  final String _libertad = 'Libertad';
  final String _emed = 'E-med';
  final String _brumed = 'Brumed';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;
    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600) {
      widthScreen = 400;
      heightScreen = 300;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.8;
      heightScreen = size.height * 0.6;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: azulRoyalTopo,
          foregroundColor: Colors.white,
          title: Text(
            "Selecione uma Empresa",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/fundos/FUNDO_BIOSAT_APP_02_640.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: GridView.count(
            crossAxisCount: sizeCrossAxisCount,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            primary: false,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: sizeAspectRatio,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(
                            empresa: _biosatMatriz);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Biosat_Fabrica_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_Biosat.png'),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Matriz Fábrica',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _biosatMatriz);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(
                            empresa: _biosatFilial);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Biosat_Adm_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_Biosat.png'),
              //     ),
              //     color: const Color.fromARGB(255, 165, 214, 255),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Filial',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _biosatFilial);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(empresa: _bigLoc);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Big_Locacao_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_big.png'),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Locação',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _bigLoc);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(empresa: _bigAt);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Big_Assistencia_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_big.png'),
              //     ),
              //     color: const Color.fromARGB(255, 165, 214, 255),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Assist.Técnica',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _bigAt);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(empresa: _emed);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Emed_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_emed.png'),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'E-med',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _emed);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(empresa: _libertad);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Liberttad_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/logo_libertad.png'),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Libertad',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _libertad);
              //         }),
              //       );
              //     },
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 220, 253)
                          .withOpacity(0.5), // Cor da sombra
                      spreadRadius: 2, // Expansão da sombra
                      blurRadius: 5, // Suavização da sombra
                      offset: Offset(3, 3), // Posição da sombra
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return PedidosPendentesAprovacao(empresa: _brumed);
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/menuEmpresas/Modulo_Compras_Brumed_02_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/Logo_Brumed.png'),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: const Color.fromARGB(255, 1, 30, 54),
              //       width: 2,
              //     ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           'Brumed',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (ctx) {
              //           return PedidosPendentesAprovacao(empresa: _brumed);
              //         }),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
