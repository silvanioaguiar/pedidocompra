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

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 116, 189, 248),
                Color.fromARGB(255, 0, 67, 122),
              ]),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // selectedTileColor: Colors.orange[100],
            // selected: active,
            title: Text(
              '${empresa.empresa}${"-"} ${empresa.valorReal}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Text(
                      'Hoje: ${empresa.valorDia}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 247, 247, 246),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                        // ElevatedButton(
                        //   style: ButtonStyle(
                        //       alignment: Alignment.centerLeft,
                        //       backgroundColor: MaterialStatePropertyAll(
                        //           Theme.of(context).primaryColor)),
                        //   onPressed: () {
                        //     // Navigator.of(context).push(
                        //     //   MaterialPageRoute(builder: (ctx) {
                        //     //     //return const MenuEmpresasFat();
                        //     //     return GraficoConvenio(empresa: "Biosat Matriz Fabrica");
                        //     //   }),
                        //     // );
                        //   },
                        //   child: Text(
                        //     'Detalhes',
                        //     style: TextStyle(
                        //       color: Theme.of(context).secondaryHeaderColor,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // subtitle: Row(
            //   children: [
            //     Column(
            //       children: [
            //         Container(
            //           padding: const EdgeInsets.symmetric(horizontal: 5),
            //           //width: double.infinity,
            //           child: ElevatedButton(
            //             style: ButtonStyle(
            //                 backgroundColor: MaterialStatePropertyAll(
            //                     Theme.of(context).primaryColor)),
            //             onPressed: () {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(builder: (ctx) {
            //                   //return const MenuEmpresasFat();
            //                   return GraficoConvenio(
            //                       empresa: "Biosat Matriz Fabrica");
            //                 }),
            //               );
            //             },
            //             child: Text(
            //               'Convênios',
            //               style: TextStyle(
            //                 color: Theme.of(context).secondaryHeaderColor,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text(
            //           'Hoje: ${empresa.valorDia}',
            //           style: const TextStyle(
            //             color: Color.fromARGB(255, 247, 247, 246),
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
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
          ),
        ),
      ),
    );
  }
}
