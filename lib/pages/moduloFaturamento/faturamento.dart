//import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoConvenio.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoRepresentante.dart';

const List<String> list = <String>[
  'Cliente',
  'Convênio',
  'Representante',
  'Ano-Mês'
];

class FaturamentoPage extends StatefulWidget {
  const FaturamentoPage({super.key});

  @override
  State<FaturamentoPage> createState() => _FaturamentoPageState();
}

class _FaturamentoPageState extends State<FaturamentoPage> {
  String dropdownValue = list.first;
  DateTime selectedDateInicio = DateTime.now();
  DateTime selectedDateFim = DateTime.now();
  bool showDateInicio = false;
  bool showDateFim = false;

  Future<DateTime> _selectDateInicio(BuildContext context) async {
    final selected = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: selectedDateInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDateInicio) {
      setState(() {
        selectedDateInicio = selected;
      });
    }
    return selectedDateInicio;
  }

  Future<DateTime> _selectDateFim(BuildContext context) async {
    final selected = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: selectedDateFim,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDateFim) {
      setState(() {
        selectedDateFim = selected;
      });
    }
    return selectedDateFim;
  }

  // Future<Widget> _graficoRepresentante(BuildContext context) async {
  //   return Builder(
  //     builder: (context) {
  //       return Row(
  //         children: [
  //           ListView(
  //             padding: EdgeInsets.all(16),
  //             children: [
  //               AspectRatio(
  //                 aspectRatio: 16 / 9,
  //                 child: DChartBarO(
  //                   vertical: false,
  //                   groupList: [
  //                     OrdinalGroup(
  //                       id: '1',
  //                       data: [
  //                         OrdinalData(domain: 'Mon', measure: 2),
  //                         OrdinalData(domain: 'Tue', measure: 6),
  //                         OrdinalData(domain: 'Wed', measure: 3),
  //                         OrdinalData(domain: 'Thu', measure: 7),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     }
  //   );
  // }

  String getDateInicio() {
    // ignore: unnecessary_null_comparison
    if (selectedDateInicio == null) {
      return 'select date';
    } else {
      return DateFormat('d MMM, yyyy', 'pt').format(selectedDateInicio);
    }
  }

  String getDateFim() {
    // ignore: unnecessary_null_comparison
    if (selectedDateFim == null) {
      return 'select date';
    } else {
      return DateFormat('d MMM, yyyy', 'pt').format(selectedDateFim);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Faturamento",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Column(
        //heightFactor: 1,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "Selecione uma opção:",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
                underline: Container(
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                    if (dropdownValue == "Representante") {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return GraficoRepresentantePage();
                        }),
                      );
                    } else if (dropdownValue == "Convênio") {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return GraficoConvenio(empresa: '',);
                        }),
                      );
                    }

                    // if (dropdownValue == "Representante") {
                    //   _graficoRepresentante(context);
                    // }
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    //width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        _selectDateInicio(context);
                        showDateInicio = true;
                      },
                      child: Text(
                        'Data Início',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                  showDateInicio
                      ? Center(child: Text(getDateInicio()))
                      : const SizedBox(width: 30),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    //width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        _selectDateFim(context);
                        showDateFim = true;
                      },
                      child: Text(
                        'Data Fim',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                  showDateFim
                      ? Center(child: Text(getDateFim()))
                      : const SizedBox(width: 30),
                ],
              ),
            ],
          ),
          // _graficoRepresentante
          // Row(
          //   children: [
          //     _graficoRepresentante
          //   ],
          // ),
        ],
      ),
    );
  }
}
