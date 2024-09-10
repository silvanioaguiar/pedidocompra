import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_localDeEntrega.dart';
import 'package:provider/provider.dart';

class FatLocalDeEntregaItem extends StatelessWidget {
  const FatLocalDeEntregaItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    final empresa = Provider.of<FaturamentoLocalDeEntrega>(context);

    var size = MediaQuery.of(context).size;
   

    return ListTile(
      title: Text(empresa.localDeEntrega),
      subtitle: Text(
        //'Valor Total: ${valor1.toString()}',
        'Valor Total: ${empresa.valorReal}',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      //leading: const Icon(Icons.account_circle),
      leading: Text(
        '${empresa.ranking}°',
        style: const TextStyle(
          color: Color.fromARGB(255, 5, 34, 58),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      //trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}


