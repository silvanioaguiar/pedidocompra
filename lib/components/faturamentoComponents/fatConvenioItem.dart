import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_convenio.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FatConvenioItem extends StatelessWidget {
  const FatConvenioItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController mycontroller = ScrollController();
    final convenio = Provider.of<FaturamentoConvenio>(context);

    var size = MediaQuery.of(context).size;
   

    return ListTile(
      title: Text('Convenio: ${convenio.convenio}'),
      subtitle: Text(
        //'Valor Total: ${valor1.toString()}',
        'Valor Total: ${convenio.valorReal}',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      //leading: const Icon(Icons.account_circle),
      leading: Text(
        '${convenio.ranking}°',
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
