import 'package:flutter/material.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/contatos.dart';
import 'package:pedidocompra/pages/crm/editarContatoCrm.dart';
import 'package:pedidocompra/pages/crm/incluirContatoCrm.dart';
import 'package:pedidocompra/providers/crm/ContatosLista.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class ContatosCrm extends StatefulWidget {
  const ContatosCrm({super.key});

  @override
  State<ContatosCrm> createState() => _ContatosCrmState();
}

class _ContatosCrmState extends State<ContatosCrm> {
  List<Contatos> contatos = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadContatos());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadContatos() async {
    final provider = Provider.of<ContatosLista>(context, listen: false);
    await provider.loadContatos(provider);
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
      heightScreen = size.height * 0.8;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.97;
      heightScreen = size.height * 0.8;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Contatos",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundos/FUNDO_BIOSAT_APP_02_640.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<ContatosLista>(
          builder: (context, contatosLista, _) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: widthScreen,
                      height: heightScreen,
                      child: ListView.builder(
                        itemCount: contatosLista.contatos.length,
                        itemBuilder: (context, index) {
                          final contato = contatosLista.contatos[index];
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
                                    contato.nome,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${contato.ddd!}-${contato.celular!}"),
                                    Text(contato.email!),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                              return EditarContatoCrm(
                                                contato: contato,
                                              );
                                            }),
                                          ).then(
                                            (_) {
                                              // Ações após o retorno
                                              _loadContatos();
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
                                                'BLOQUEAR CONTATO',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Tem certeza que deseja bloquear esse contato? Uma vez bloqueado somente o administrador do sistema poderá desbloquear.',
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
                                                            ContatosLista>(
                                                      context,
                                                      listen: false,
                                                    )
                                                        .bloquearContato(
                                                            context,
                                                            contato.codigo)
                                                        .then(
                                                      (_) {
                                                        // Ações após o retorno
                                                        _loadContatos();
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
                                  return const IncluirContatoCrm();
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
