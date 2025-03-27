import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/pages/crm/editarConcorrenteCrm.dart';
import 'package:pedidocompra/pages/crm/incluirConcorrenteCrm.dart';
import 'package:provider/provider.dart';

class ConcorrentesCrm extends StatefulWidget {
  const ConcorrentesCrm({super.key});

  @override
  State<ConcorrentesCrm> createState() => _ConcorrentesCrmState();
}

class _ConcorrentesCrmState extends State<ConcorrentesCrm> {
  List<Concorrentes> _concorrentes = [];

  @override
  void initState() {
    super.initState();
    _loadConcorrentes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadConcorrentes() async {
    final provider = Provider.of<ConcorrentesLista>(context, listen: false);
    final concorrentes = await provider.loadConcorrentes(provider);

    setState(() {
      _concorrentes = concorrentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;

    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600) {
      widthScreen = 400;
      heightScreen = 300;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.8;
      heightScreen = size.height * 0.6;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Concorrentes",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _concorrentes.length,
                itemBuilder: (context, index) {
                  final concorrente = _concorrentes[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                        title: SizedBox(
                          width: 100,
                          child: Text(
                            concorrente.nomeFantasia,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text(concorrente.endereco!),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (ctx) {
                                      return EditarConcorrenteCrm(
                                        concorrente: _concorrentes[index],
                                      );
                                    }),
                                  ).then(
                                    (_) {
                                      // Ações após o retorno
                                      _loadConcorrentes();
                                      setState(() {
                                         
                                      });
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 153, 0),
                                ),
                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ),
                            
                          ],
                        )),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return  IncluirConcorrenteCrm();
                        }),
                      );
                    },
                    backgroundColor: const Color.fromARGB(255, 0, 40, 73),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
