import 'package:flutter/material.dart';

class PedidosPendentes extends StatelessWidget {
  const PedidosPendentes({super.key});

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
          ListTile(
            tileColor: Theme.of(context).secondaryHeaderColor,
            leading: CircleAvatar(child: Text('A')),
            // leading: SingleChildScrollView(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           color: Color.fromARGB(255, 16, 19, 168),
            //           border: Border.all(
            //             color: Theme.of(context).colorScheme.primary,
            //             width: 0.5,
            //           ),
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(10),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            title: const Text(
              "N° Pedido:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // subtitle: Text('Fornecedor:'),
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fornecedor:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(),
                Text(
                  'Valor:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            //isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.beenhere_sharp,color: Color.fromARGB(255, 5, 90, 8),),tooltip: "Aprovar",),
                IconButton(onPressed: () {}, icon: const Icon(Icons.cancel,color: Colors.red),tooltip: "Cancelar",),
                IconButton(onPressed: () {}, icon: const Icon(Icons.list_alt),tooltip: 'Vizualizar Pedido',),
              ],
            ),
          ),
          const Divider(height: 5),
          ListTile(
            tileColor: Theme.of(context).secondaryHeaderColor,
            // leading: CircleAvatar(child: Text('A')),
            // leading: SingleChildScrollView(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           color: Color.fromARGB(255, 16, 19, 168),
            //           border: Border.all(
            //             color: Theme.of(context).colorScheme.primary,
            //             width: 0.5,
            //           ),
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(10),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            title: const Text(
              "N° Pedido:",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Fornecedor:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Text(
              'Valor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
