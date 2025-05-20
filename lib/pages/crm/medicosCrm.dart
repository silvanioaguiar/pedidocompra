import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/pages/crm/editarMedicoCrm.dart';
import 'package:pedidocompra/pages/crm/incluirMedico.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/pages/crm/editarConcorrenteCrm.dart';
import 'package:pedidocompra/providers/crm/medicosLista.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';

class MedicosCrm extends StatefulWidget {
  const MedicosCrm({super.key});

  @override
  State<MedicosCrm> createState() => _MedicosCrmState();
}

class _MedicosCrmState extends State<MedicosCrm> {
  List<Medicos> medicos = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadMedicos());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadMedicos() async {
    final provider = Provider.of<MedicosLista>(context, listen: false);
    await provider.loadMedicos(provider);
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
      widthScreen = size.width * 0.9;
      heightScreen = size.height * 0.8;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Médicos",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Consumer<MedicosLista>(
        builder: (context, medicosLista, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: widthScreen ,
                    height: heightScreen,
                    child: ListView.builder(
                      itemCount: medicosLista.medicos.length,
                      itemBuilder: (context, index) {
                        final medico = medicosLista.medicos[index];
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
                                  medico.nomeMedico,
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Text(medico.especialidade!),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (ctx) {
                                            return EditarMedicoCrm(
                                              medico: medico,
                                            );
                                          }),
                                        ).then(
                                          (_) {
                                            // Ações após o retorno
                                            _loadMedicos();
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
                                  Flexible(
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                              'BLOQUEAR MÉDICO',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: const Text(
                                              'Tem certeza que deseja bloquear esse médico ? Uma vez bloqueado somente o administrador do sistema poderá desbloquear.',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  NavigatorService.instance.pop();
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
                                                  NavigatorService.instance.pop();
                                                  await Provider.of<MedicosLista>(
                                                    context,
                                                    listen: false,
                                                  )
                                                      .bloquearMedico(
                                                          context, medico.codigo)
                                                      .then(
                                                    (_) {
                                                      // Ações após o retorno
                                                      _loadMedicos();
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
                                return IncluirMedicoCrm();
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
        },
      ),
    );
  }
}
