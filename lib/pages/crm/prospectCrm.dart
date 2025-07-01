import 'package:flutter/material.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/propects.dart';
import 'package:pedidocompra/pages/crm/editarProspectCrm.dart';
import 'package:pedidocompra/pages/crm/incluirProspectCrm.dart';
import 'package:pedidocompra/providers/crm/prospectsLista.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class ProspectCrm extends StatefulWidget {
  const ProspectCrm({super.key});

  @override
  State<ProspectCrm> createState() => _ProspectCrmState();
}

class _ProspectCrmState extends State<ProspectCrm> {
  List<Prospects> prospects = [];
  List<Prospects> registrosFiltrados = [];
  TextEditingController controllerPesquisa = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadProspects());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadProspects() async {
    final provider = Provider.of<ProspectsLista>(context, listen: false);
    await provider.loadProspects(provider);
  }

  void _filtrarRegistros(ProspectsLista prospectsLista) {
    final query = controllerPesquisa.text.toLowerCase();
    setState(() {
      registrosFiltrados = prospectsLista.prospects.where((prospect) {
        return prospect.nomeFantasia.toLowerCase().contains(query);
      }).toList();
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
      widthScreen = size.width * 0.5;
      heightScreen = size.height * 0.75;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.9;
      heightScreen = size.height * 0.65;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Prospects",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/fundos/FUNDO_BIOSAT_APP_02_640.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<ProspectsLista>(
         builder: (context, prospectsLista, _) {
            if (prospectsLista.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: azulRoyalTopo,
                ),
              );
            }
            // Aplica a filtragem quando o texto mudar
            controllerPesquisa.addListener(() {
              _filtrarRegistros(prospectsLista);
            });

            final listaExibida = controllerPesquisa.text.isEmpty
                ? prospectsLista.prospects
                : registrosFiltrados;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controllerPesquisa,
                        decoration: const InputDecoration(
                          labelText: 'Pesquisar',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: widthScreen,
                      height: heightScreen,
                      child: ListView.builder(
                        itemCount: listaExibida.length,
                        itemBuilder: (context, index) {
                          final prospect = listaExibida[index];
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
                                    prospect.nomeFantasia,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(prospect.endereco!),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                              return EditarProspectCrm(
                                                prospect: prospect,
                                              );
                                            }),
                                          ).then(
                                            (_) {
                                              // Ações após o retorno
                                              _loadProspects();
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color:
                                              Color.fromARGB(255, 255, 153, 0),
                                        ),
                                        //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                'BLOQUEAR PROSPECT',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Tem certeza que deseja bloquear esse prospect ? Uma vez bloqueado somente o administrador do sistema poderá desbloquear.',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    NavigatorService.instance
                                                        .pop();
                                                  },
                                                  child: const Text("Cancelar",
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 5, 0, 0))),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    NavigatorService.instance
                                                        .pop();
                                                    await Provider.of<
                                                            ProspectsLista>(
                                                      context,
                                                      listen: false,
                                                    )
                                                        .bloquearProspect(
                                                            context,
                                                            prospect.codigo)
                                                        .then(
                                                      (_) {
                                                        // Ações após o retorno
                                                        _loadProspects();
                                                      },
                                                    );
                                                  },
                                                  child: const Text("Bloquear",
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 5, 0, 0))),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.block,
                                          color: Color.fromARGB(255, 255, 0, 0),
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
                                  return IncluirProspectCrm();
                                }),
                              );
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 0, 40, 73),
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
          },
        ),
      ),
    );
  }
}
