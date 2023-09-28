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
      body: Stack(
        children: <Widget>[
          Row(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Fornecedor:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(),
                  Text(
                    "Pedido:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(),
                  Text(
                    "Valor:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 200),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.beenhere_sharp,
                            color: Color.fromARGB(255, 5, 90, 8)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        tooltip: "Cancelar",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
