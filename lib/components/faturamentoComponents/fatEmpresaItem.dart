import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fatLocalDeEntrega.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fatNotasDoDia.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fatNotasDoPeriodo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FatEmpresaItem extends StatelessWidget {
  const FatEmpresaItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _mycontroller = new ScrollController();
    final empresa = Provider.of<FaturamentoEmpresas>(context);
    var _detalhesFaturamento = [
      'Local de Entrega',
      'NFs de Hoje',
      'NFs do Período',
    ];
    var _itemSelecionado = 'NFs de Hoje';

    var size = MediaQuery.of(context).size;
    var dateIni =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(empresa.dateIni));
    var dateFim =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(empresa.dateFim));
    final dateIniFormate = DateTime.parse(dateIni);
    final dateFimFormate = DateTime.parse(dateFim);
    var valorDiaFormatado = empresa.valorDia;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(1),
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
              '${empresa.empresa}${" "} ${empresa.valorReal}',
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
                    width: 180,
                    child: Text(
                      'Hoje: ${empresa.valorDia}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 247, 247, 246),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(canvasColor: Colors.blue),
                          child: DropdownButton<String>(
                            items: _detalhesFaturamento
                                .map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  dropDownStringItem,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              if (value == 'Local de Entrega') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return FatLocalDeEntrega(
                                      empresa: empresa.empresa,
                                      dateIni: dateIniFormate,
                                      dateFim: dateFimFormate,
                                    );
                                  }),
                                );
                              } else if (value == 'NFs do Período') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return FatNotasDoPeriodo(
                                      empresa: empresa.empresa,
                                      dateIni: dateIniFormate,
                                      dateFim: dateFimFormate,
                                    );
                                  }),
                                );
                              } else if (value == 'NFs de Hoje') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return FatNotasDoDia(
                                      empresa: empresa.empresa,
                                      dateIni: dateIniFormate,
                                      dateFim: dateFimFormate,
                                      valorDiaFormatado: valorDiaFormatado,
                                    );
                                  }),
                                );
                              }
                            },
                            value: _itemSelecionado,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
