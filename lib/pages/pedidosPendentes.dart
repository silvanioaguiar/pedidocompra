import 'package:flutter/material.dart';
import 'package:pedidocompra/models/pedidosLista.dart';
import 'package:provider/provider.dart';



bool isLoading = true;

class PedidosPendentesAprovacao extends StatefulWidget {
  const PedidosPendentesAprovacao({super.key});

  @override
  State<PedidosPendentesAprovacao> createState() => _PedidosPendentesAprovacaoState();
}

class _PedidosPendentesAprovacaoState extends State<PedidosPendentesAprovacao> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<PedidosLista>(
      context,
      listen: false,
     ).loadPedidos().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

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
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 150, 35, 27),
                  ],
                ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 102, 245)),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 34, 185, 39)),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel,
                                  color: Color.fromARGB(255, 247, 43, 43)),
                              iconSize: 30,
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              color: Colors.white,
                              iconSize: 30,
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
                                  color: Color.fromARGB(255, 34, 185, 39),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 43, 43),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Colors.white,
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
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 150, 35, 27),
                  ],
                ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 102, 245)),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 34, 185, 39)),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel,
                                  color: Color.fromARGB(255, 247, 43, 43)),
                              iconSize: 30,
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              color: Colors.white,
                              iconSize: 30,
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
                                  color: Color.fromARGB(255, 34, 185, 39),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 43, 43),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Colors.white,
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
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 150, 35, 27),
                  ],
                ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 102, 245)),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 34, 185, 39)),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel,
                                  color: Color.fromARGB(255, 247, 43, 43)),
                              iconSize: 30,
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              color: Colors.white,
                              iconSize: 30,
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
                                  color: Color.fromARGB(255, 34, 185, 39),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 43, 43),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Colors.white,
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
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 150, 35, 27),
                  ],
                ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 102, 245)),
                        ),
                        const SizedBox(),
                        const Text(
                          "Fornecedor: American Implantes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Pedido: 594000",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                        const Text(
                          "Valor: 30.000,00",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "C. Pgto:30/60/90/120/150",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),
                        Row(
                          children: [
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.beenhere_sharp,
                                  color: Color.fromARGB(255, 34, 185, 39)),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel,
                                  color: Color.fromARGB(255, 247, 43, 43)),
                              iconSize: 30,
                              tooltip: "Cancelar",
                            ),
                            const SizedBox(width: 60),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.list_alt),
                              color: Colors.white,
                              iconSize: 30,
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
                                  color: Color.fromARGB(255, 34, 185, 39),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 43, 43),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              'Visualizar',
                              style: TextStyle(
                                  color: Colors.white,
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
