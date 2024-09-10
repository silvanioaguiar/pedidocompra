import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_convenioLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_convenio.dart';
import 'package:provider/provider.dart';

bool isLoading = true;

class GraficoConvenio extends StatelessWidget {
  const GraficoConvenio({super.key, required this.empresa});
  final String empresa;

  @override
  Widget build(BuildContext context) {
    String xempresa = '';

   

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    //final double itemWidth = size.width / 2;
    final ScrollController mycontroller = ScrollController();
    final provider = Provider.of<FatConvenioLista>(context);
    final List<FaturamentoConvenio> loadedConvenios = provider.convenios;
    final convenios = Provider.of<FaturamentoConvenio>(context);
    //String valor1 = NumberFormat.currency(locale: 'br_Br', symbol: "R\$")
    //    .format(convenios.valor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Faturamento por Convênio",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: loadedConvenios.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: loadedConvenios[index],
          child: ListTile(
            title: Text('Convenio: ${convenios.convenio}'),
            //subtitle: Text(
              //'Valor Total: ${valor1.toString()}',
           // ),
            leading: const Icon(Icons.account_circle),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
