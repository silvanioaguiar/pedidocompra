import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/pages/crm/agendaCrm.dart';
//import 'package:pedidocompra/pages/crm/clientesCrm.dart';
import 'package:pedidocompra/pages/crm/concorrentesCrm.dart';
import 'package:pedidocompra/pages/crm/contatosCrm.dart';
import 'package:pedidocompra/pages/crm/medicosCrm.dart';
import 'package:pedidocompra/pages/crm/prospectCrm.dart';
import 'package:pedidocompra/pages/crm/relatorioVisitasCrm.dart';
import 'package:pedidocompra/providers/crm/ContatosLista.dart';
import 'package:provider/provider.dart';

class MenuCrm extends StatefulWidget {
  const MenuCrm({super.key});

  @override
  State<MenuCrm> createState() => _MenuCrmState();
}

class _MenuCrmState extends State<MenuCrm> {
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
      sizeAspectRatio = 2.0;
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
            "Selecione uma Opção",
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
              image: AssetImage('assets/images/fundos/FUNDO_BIOSAT_APP_640.jpg'),
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
                        return const AgendaCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Agenda_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   width: ,
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //         image: AssetImage('assets/images/iconesCrm/Agenda.png'),
              //         scale: 0.6),
              //     //color: const Color.fromARGB(255, 165, 214, 255),
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(
              //     //   color: const Color.fromARGB(255, 1, 30, 54),
              //     //   width: 2,
              //     // ),
              //   ),
              //   child: TextButton(
              //     child: const Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Text(
              //           '',
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
              //           return const AgendaCrm();
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
                        return const ContatosCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Contatos_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //         image: AssetImage('assets/images/Contatos.png'),
              //         scale: 0.7),
              //     //color: const Color.fromARGB(255, 165, 214, 255),
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
              //           'Contatos',
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
              //           return const ContatosCrm();
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
                        return const ConcorrentesCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Concorrentes_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //         image: AssetImage('assets/images/customers.png'),
              //         scale: 0.7),
              //     //color: const Color.fromARGB(255, 165, 214, 255),
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
              //           'Concorrentes',
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
              //           return const ConcorrentesCrm();
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
                        return const ProspectCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Prospects_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //         image: AssetImage('assets/images/teamwork.png'),
              //         scale: 0.7),
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
              //           'Propects',
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
              //           return const ProspectCrm();
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
                        return const MedicosCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Medicos_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/customers.png'),
              //     ),
              //     //color: const Color.fromARGB(255, 165, 214, 255),
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
              //           'Médicos',
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
              //           return const MedicosCrm();
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
                        return const RelatorioVisitasCrm();
                      }),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/iconesCrm/Visitas_tipo2.png',
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/images/customers.png'),
              //     ),
              //     //color: const Color.fromARGB(255, 165, 214, 255),
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
              //           'Relatório de Visitas',
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
              //           final contatosLista =
              //               Provider.of<ContatosLista>(context);
              //           return const RelatorioVisitasCrm();
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
