import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/faturamentoComponents/fat_notasDoPeriodo_grid.dart';
import 'package:pedidocompra/providers/faturamento/fat_notasDoPeriodoLista.dart';
import 'package:provider/provider.dart';

bool isLoading = true;

class FatNotasDoPeriodo extends StatefulWidget {
  final String empresa;
  final DateTime dateIni;
  final DateTime dateFim;

  const FatNotasDoPeriodo({super.key, required this.empresa, required this.dateIni, required this.dateFim});

  @override
  State<FatNotasDoPeriodo> createState() => _FatNotasDoPeriodoState();
}

class _FatNotasDoPeriodoState extends State<FatNotasDoPeriodo> {
  bool _isLoading = true;
  String xempresa = '';
  DateTime xdateIni = DateTime.now();
  DateTime xdateFim = DateTime.now();
  //String dropdownValue = list.first;
  DateTime now = DateTime.now();
  static DateTime selectedDateFim = DateTime.now();
  DateTime selectedDateInicio = selectedDateFim.add(const Duration(days: -30));
  bool showDateInicio = false;
  bool showDateFim = false;
  var logo;
  DateTime dataAtual = DateTime.now();

  DateTime primeiroDiaDoMes(DateTime data) {
    return DateTime(data.year, data.month, 1);
  }

  @override
  void initState() {
    xempresa = widget.empresa;
    xdateIni = widget.dateIni;
    xdateFim = widget.dateFim;
    super.initState();

    //selectedDateInicio = primeiroDiaDoMes(dataAtual);

    Provider.of<FatNotasDoPeriodoLista>(
      context,
      listen: false,
    )
        .loadNotasDoPeriodo(
            context, xempresa, xdateIni, xdateFim)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshNotasDoPeriodo(BuildContext context) {
    return Provider.of<FatNotasDoPeriodoLista>(
      context,
      listen: false,
    ).loadNotasDoPeriodo(
        context, xempresa, selectedDateInicio, selectedDateFim);
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
    if (xempresa.trim() == 'Big Manutencao' ||
        xempresa.trim() == 'Big Locacao') {
      logo = 'assets/images/logo_big.png';
    } else if (xempresa.trim() == 'Biosat Matriz' ||
        xempresa.trim() == 'Biosat Filial') {
      logo = 'assets/images/logo_biosat2.png';
    } else if (xempresa.trim() == 'Libertad') {
      logo = 'assets/images/logo_libertad.png';
    } else if (xempresa.trim() == 'E-med') {
      logo = 'assets/images/logo_emed.png';
    } else if (xempresa.trim() == 'Brumed') {
      logo = 'assets/images/logo_Brumed.png';
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            "NFs Emitidas no Periodo Selecionado",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        //drawer: AppDrawer(),
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
                    SizedBox(
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
                                            WidgetStatePropertyAll(
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
                                              .format(xdateIni),
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
                                            WidgetStatePropertyAll(
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
                                              .format(xdateFim),
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
                                              WidgetStatePropertyAll(
                                                  Color.fromARGB(
                                                      255, 202, 14, 1))),
                                      onPressed: () =>
                                          _refreshNotasDoPeriodo(context),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Column(
                  //   children: [
                  //     Container(
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 5, vertical: 5),
                  //       //width: double.infinity,
                  //       child: const Text(
                  //         'Posição',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 18,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(width: 50),
                  SizedBox(
                    height: 40,
                    width: 200,
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    // //width: double.infinity,
                    child:  Text(
                      xempresa,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                      ),
                    ),
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
              onRefresh: () => _refreshNotasDoPeriodo(context),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const FatNotasDoPeriodoGrid(),
            ),
          ],
        ));
  }
}
