import 'package:flutter/material.dart';

class PedidosPendentesAprovacao extends StatelessWidget {
  const PedidosPendentesAprovacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Pedidos Aguardando Aprovação",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: EdgeInsets.all(2),
              //color: Color.fromARGB(255, 171, 209, 224),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 184, 224, 240),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_biosat2.png'),
                  alignment: Alignment.topRight,
                ),
              ),
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Empresa: Biosat",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 5, 90, 8)),
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              tooltip: 'Vizualizar Pedido',
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 60),
                            Text(
                              'Aprovar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 85, 21),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 170, 24, 13),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 58, 99),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: EdgeInsets.all(2),
              //color: Color.fromARGB(255, 171, 209, 224),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 184, 224, 240),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage('assets/images/Logo_Brumed.png'),
                  alignment: Alignment.topRight,
                ),
              ),
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Empresa: Brumed",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 5, 90, 8)),
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              tooltip: 'Vizualizar Pedido',
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 60),
                            Text(
                              'Aprovar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 85, 21),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 170, 24, 13),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 58, 99),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: EdgeInsets.all(2),
              //color: Color.fromARGB(255, 171, 209, 224),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 184, 224, 240),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_biosat2.png'),
                  alignment: Alignment.topRight,
                ),
              ),
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Empresa: Biosat",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 5, 90, 8)),
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              tooltip: 'Vizualizar Pedido',
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 60),
                            Text(
                              'Aprovar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 85, 21),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 170, 24, 13),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 58, 99),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: EdgeInsets.all(2),
              //color: Color.fromARGB(255, 171, 209, 224),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 184, 224, 240),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_biosat2.png'),
                  alignment: Alignment.topRight,
                ),
              ),
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Empresa: Biosat",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 5, 90, 8)),
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              tooltip: 'Vizualizar Pedido',
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            SizedBox(width: 60),
                            Text(
                              'Aprovar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 85, 21),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 170, 24, 13),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 58, 99),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
