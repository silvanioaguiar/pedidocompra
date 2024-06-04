import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
//import 'package:pedidocompra/components/fatConvenioItem.dart';
import 'package:pedidocompra/components/faturamentoComponents/fat_convenio_grid.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_convenioLista.dart';
import 'package:provider/provider.dart';

bool isLoading = true;

class GraficoConvenio extends StatefulWidget {
  final String empresa;

  GraficoConvenio({super.key, required this.empresa});

  @override
  State<GraficoConvenio> createState() => _GraficoConvenioState();
}

class _GraficoConvenioState extends State<GraficoConvenio> {
  bool _isLoading = true;
  String xempresa = '';
  //String dropdownValue = list.first;
  DateTime now = DateTime.now();
  static DateTime selectedDateFim = DateTime.now();
  DateTime selectedDateInicio = selectedDateFim.add(const Duration(days: -30));
  bool showDateInicio = false;
  bool showDateFim = false;
  var logo;

  @override
  void initState() {
    xempresa = widget.empresa;
    super.initState();

    Provider.of<FatConvenioLista>(
      context,
      listen: false,
    )
        .loadConvenios(context, xempresa, selectedDateInicio, selectedDateFim)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshConvenios(BuildContext context) {
    return Provider.of<FatConvenioLista>(
      context,
      listen: false,
    ).loadConvenios(context, xempresa, selectedDateInicio, selectedDateFim);
  }

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
    var size = MediaQuery.of(context).size;
    if (xempresa == 'Big Assistencia Tecnica' || xempresa == 'Big Locacao') {
      logo = 'assets/images/logo_big.png';
    } else if (xempresa == 'Biosat Matriz Fabrica' ||
        xempresa == 'Biosat Filial') {
      logo = 'assets/images/logo_biosat2.png';
    } else if (xempresa == 'Libertad') {
      logo = 'assets/images/logo_libertad.png';
    } else if (xempresa == 'E-med') {
      logo = 'assets/images/logo_emed.png';
    } else if (xempresa == 'Brumed') {
      logo = 'assets/images/logo_Brumed.png';
    }
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
                    Container(
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  //width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .primaryColor)),
                                    onPressed: () {
                                      _selectDateInicio(context);
                                      showDateInicio = true;
                                    },
                                    child: Text(
                                      'Data Início',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ),
                                showDateInicio
                                    ? Center(
                                        child: Text(
                                          getDateInicio(),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .primaryColor)),
                                    onPressed: () {
                                      _selectDateFim(context);
                                      showDateFim = true;
                                    },
                                    child: Text(
                                      'Data Fim',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                  ),
                                ),
                                showDateFim
                                    ? Center(
                                        child: Text(
                                          getDateFim(),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                            color:
                                                Theme.of(context).primaryColor,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    //width: double.infinity,
                                    child: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color.fromARGB(
                                                      255, 202, 14, 1))),
                                      onPressed: () =>
                                          _refreshConvenios(context),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        //width: double.infinity,
                        child: const Text(
                          'Posição',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     Container(
                  //       child: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(15)),
                  //         image: DecorationImage(
                  //           image: AssetImage(logo),
                  //           alignment: Alignment.topRight,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: () => _refreshConvenios(context),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const FatConvenioGrid(),
            ),
          ],
        ));
  }
}
