import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/pages/crm/agendaCrm.dart';
import 'package:pedidocompra/pages/crm/clientesCrm.dart';
import 'package:pedidocompra/pages/crm/concorrentesCrm.dart';
import 'package:pedidocompra/pages/crm/faturamentoCrm.dart';
import 'package:pedidocompra/pages/crm/formularioCrm.dart';
import 'package:pedidocompra/pages/crm/prospectCrm.dart';

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
          backgroundColor: Theme.of(context).primaryColor,
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
        body: GridView.count(
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/agenda.png'),scale:0.6

                ),
                //color: const Color.fromARGB(255, 165, 214, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Agenda',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const AgendaCrm();
                    }),
                  );
                },
              ),
            ),           
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/customers.png'),scale:0.7

                ),
                //color: const Color.fromARGB(255, 165, 214, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Clientes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const ClientesCrm();
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/customers.png'),scale:0.7

                ),
                //color: const Color.fromARGB(255, 165, 214, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Concorrentes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const ConcorrentesCrm();
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/teamwork.png'),scale:0.7
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Propects',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const ProspectCrm();
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/formularios.png'),
                ),
                //color: const Color.fromARGB(255, 165, 214, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Formulários',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const FormularioCrm();
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/money.png'),
                ),
                //color: const Color.fromARGB(255, 165, 214, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 1, 30, 54),
                  width: 2,
                ),
              ),
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Faturamento',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const FaturamentoCrm();
                    }),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
