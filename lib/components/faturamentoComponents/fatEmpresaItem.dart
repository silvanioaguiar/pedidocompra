import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoConvenio.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FatEmpresaItem extends StatelessWidget {
  const FatEmpresaItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _mycontroller = new ScrollController();
    final empresa = Provider.of<FaturamentoEmpresas>(context);

    var size = MediaQuery.of(context).size;

    return ListTile(
      title: Text('${empresa.empresa} ${" - "} ${empresa.valorReal}'),
      // subtitle: Text(
      //   //'Valor Total: ${valor1.toString()}',
      //   'Valor Total: ${empresa.valorReal}',
      //   style: const TextStyle(
      //     color: Colors.black,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      subtitle: Row(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                //width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor)),
                  onPressed: () {
                   Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) {
                                //return const MenuEmpresasFat();
                                return  GraficoConvenio(empresa: "Biosat Matriz Fabrica");
                              }),
                            );
                  },
                  child: Text(
                    'Convênios',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ],
      ),
      //leading: const Icon(Icons.account_circle),
      // leading: Text(
      //   '${convenio.ranking}°',
      //   style: const TextStyle(
      //     color: Color.fromARGB(255, 5, 34, 58),
      //     fontSize: 24,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      //trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
