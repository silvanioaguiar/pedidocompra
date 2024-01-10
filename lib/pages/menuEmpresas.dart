import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/pages/pedidosPendentes.dart';

class MenuEmpresas extends StatefulWidget {
  const MenuEmpresas({super.key});

  @override
  State<MenuEmpresas> createState() => _MenuEmpresasState();
}


class _MenuEmpresasState extends State<MenuEmpresas> {

  final String _bigAt = "Big Assistencia Tecnica";
  final String _bigLoc = "Big Locacao";
  final String _biosatMatriz = 'Biosat Matriz Fabrica';
  final String _biosatFilial = 'Biosat Filial';
  final String _libertad = 'Libertad';
  final String _emed = 'E-med';
  final String _brumed = 'Brumed';


  @override
  Widget build(BuildContext context) {    
    
    return Scaffold(        
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            "Selecione uma Empresa",
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
                      return  PedidosPendentesAprovacao(empresa:  _biosatMatriz);
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
