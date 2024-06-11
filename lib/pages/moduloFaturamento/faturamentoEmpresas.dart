import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/faturamentoComponents/fat_empresas_grid.dart';
import 'package:pedidocompra/components/faturamentoComponents/fat_empresas_total.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_empresaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:provider/provider.dart';

class FaturamentoEmpresasPage extends StatefulWidget {
  const FaturamentoEmpresasPage({super.key});

  @override
  State<FaturamentoEmpresasPage> createState() =>
      _FaturamentoEmpresasFatState();
}

class _FaturamentoEmpresasFatState extends State<FaturamentoEmpresasPage> {
  final String _bigAt = "Big Assistencia Tecnica";
  final String _bigLoc = "Big Locacao";
  final String _biosatMatriz = 'Biosat Matriz Fabrica';
  final String _biosatFilial = 'Biosat Filial';
  final String _libertad = 'Libertad';
  final String _emed = 'E-med';
  final String _brumed = 'Brumed';

  bool _isLoading = true;
  String xempresa = 'Biosat Matriz Fabrica';
  //String dropdownValue = list.first;
  DateTime dataAtual = DateTime.now();
  static DateTime selectedDateFim = DateTime.now();
  //DateTime selectedDateInicio = selectedDateFim.add(const Duration(days: -30));
  DateTime selectedDateInicio = DateTime.utc(2000, 01, 01);

  bool showDateInicio = false;
  bool showDateFim = false;
  var logo;

  DateTime primeiroDiaDoMes(DateTime data) {
    return DateTime(data.year, data.month, 1);
  }

  @override
  void initState() {
    super.initState();

    selectedDateInicio = primeiroDiaDoMes(dataAtual);
    Provider.of<FatEmpresaLista>(
      context,
      listen: false,
    )
        .loadEmpresas(context, xempresa, selectedDateInicio, selectedDateFim)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshEmpresas(BuildContext context) async {
    return await Provider.of<FatEmpresaLista>(
      context,
      listen: false,
    )
        .loadEmpresas(context, xempresa, selectedDateInicio, selectedDateFim)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<DateTime> _selectDateInicio(BuildContext context) async {
    final selected = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: selectedDateInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
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
            "Faturamento Empresas",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 191, 1)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Filtro',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              //width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).primaryColor)),
                                onPressed: () {
                                  _selectDateInicio(context);
                                  showDateInicio = true;
                                },
                                child: Text(
                                  'Data Início',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ),
                            showDateInicio
                                ? Center(
                                    child: Text(
                                      getDateInicio(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                //: const SizedBox(width: 25),
                                : Center(
                                    child: Text(
                                      DateFormat('d MMM, yyyy', 'pt')
                                          .format(selectedDateInicio),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              //width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).primaryColor)),
                                onPressed: () {
                                  _selectDateFim(context);
                                  showDateFim = true;
                                },
                                child: Text(
                                  'Data Fim',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ),
                            showDateFim
                                ? Center(
                                    child: Text(
                                      getDateFim(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                //: const SizedBox(width: 25),
                                : Center(
                                    child: Text(
                                      DateFormat('d MMM, yyyy', 'pt')
                                          .format(selectedDateFim),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                //width: double.infinity,
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(255, 202, 14, 1))),
                                  // onPressed: () {
                                  //   _isLoading = true;
                                  //   _refreshEmpresas(context);
                                  // } ,
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      _refreshEmpresas(context);
                                    });
                                  },
                                  child: Text(
                                    'Atualizar',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 80,
                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).primaryColor,
                        // ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        //width: double.infinity,
                        child: _isLoading
                            ? const Text(
                                'Total Faturado: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const FatEmpresasTotal(),                     
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Column(
                  //   children: [
                  //     Container(
                  //       height: 40,
                  //       // decoration: BoxDecoration(
                  //       //   color: Theme.of(context).primaryColor,
                  //       // ),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 15, vertical: 5),
                  //       //width: double.infinity,
                  //       child: 
                  //            Text(
                  //               'Total do Dia: ',
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             )
                                              
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: () => _refreshEmpresas(context),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const FatEmpresasGrid(),
            ),
          ],
        ));
  }
}
