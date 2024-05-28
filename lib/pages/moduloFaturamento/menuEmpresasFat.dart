import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_empresaLista.dart';
import 'package:pedidocompra/pages/moduloFaturamento/graficoConvenio.dart';
import 'package:pedidocompra/pages/moduloCompras/pedidosPendentes.dart';
import 'package:provider/provider.dart';

class MenuEmpresasFat extends StatefulWidget {
  const MenuEmpresasFat({super.key});

  @override
  State<MenuEmpresasFat> createState() => _MenuEmpresasFatState();
}


class _MenuEmpresasFatState extends State<MenuEmpresasFat> {

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
  DateTime now = DateTime.now();
  static DateTime selectedDateFim = DateTime.now();
  DateTime selectedDateInicio = selectedDateFim.add(const Duration(days: -30));
  bool showDateInicio = false;
  bool showDateFim = false;
  var logo;

  @override
  void initState() {
    
    super.initState();

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

  Future<void> _refreshEmpresas(BuildContext context) {
    return Provider.of<FatEmpresaLista>(
      context,
      listen: false,
    ).loadEmpresas(context, xempresa, selectedDateInicio, selectedDateFim);
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
    
    return Scaffold(        
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            "Selecione uma Empresa#",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          primary: false,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 85, 170, 250),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Biosat Matriz Fábrica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  GraficoConvenio(empresa: _biosatMatriz);
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 1, 64, 122),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Biosat Filial',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _biosatFilial);
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 109, 2, 2),
                    Color.fromARGB(255, 217, 230, 241),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Big Locação',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _bigLoc);
                    }),
                  );
                
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 71, 1, 1),
                    Color.fromARGB(255, 160, 42, 42),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Big Assistência Técnica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _bigAt);
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 5, 34, 58),
                    Color.fromARGB(255, 85, 170, 250),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'E-med',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _emed);
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 71, 1, 1),
                    Color.fromARGB(255, 58, 59, 59),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Libertad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _libertad);
                    }),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //Color.fromARGB(255, 5, 34, 58),
                    //Color.fromARGB(255, 150, 35, 27),
                    Color.fromARGB(255, 71, 1, 1),
                    Color.fromARGB(255, 42, 42, 77),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(
                child: const Text(
                  'Brumed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return  PedidosPendentesAprovacao(empresa:  _brumed);
                    }),
                  );
                },
              ),
            ),
            
          ],
        ));
  }
}
