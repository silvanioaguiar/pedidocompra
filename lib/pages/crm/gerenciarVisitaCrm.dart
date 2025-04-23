import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/hospitais.dart';
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/pages/crm/editarAgendaCrm.dart';
import 'package:pedidocompra/pages/crm/editarFormularioVisitaCrm.dart';
import 'package:pedidocompra/pages/crm/formularioVisitaCrm.dart';
import 'package:pedidocompra/providers/crm/formularioVisitaProvider.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:pedidocompra/services/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class GerenciarVisitaCrm extends StatefulWidget {
  Event event;

  GerenciarVisitaCrm({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<GerenciarVisitaCrm> createState() => _GerenciarVisitaCrmState();
}

class _GerenciarVisitaCrmState extends State<GerenciarVisitaCrm> {
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");

  String? _representanteSelecionado;

  DateTime? dataSelecionada = DateTime.now();
  TimeOfDay? horaSelecionada = TimeOfDay.fromDateTime(DateTime.now());

  List<Visitas>? loadedVisitas;
  List<Visitas>? loadedVisitaUnica;
  List<Concorrentes> concorrentes = [];
  List<Hospitais> hospitais = [];
  List<String> filteredOptions = [];
  List<Hospitais> filteredHospitais = [];
  List<Concorrentes> filteredConcorrentes = [];
  List<String> selectedHospitais = [];
  List<String> selectedConcorrentes = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController selectedItemsController = TextEditingController();
  TextEditingController searchControllerConcorrentes = TextEditingController();
  TextEditingController selectedItemsControllerConcorrentes =
      TextEditingController();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ValueNotifier<List<Event>> _selectedEvents;

  TextStyle styleButton =
      const TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  TextStyle styleNames = const TextStyle(
    fontFamily: 'Verdana',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 160, 8, 8),
  );

  // @override
  // void initState() {
  //   super.initState();
  //   _loadVisitas;
  // }

  Future<void> _loadVisitaUnica() async {
    var provider = Provider.of<VisitasLista>(context, listen: false);
    loadedVisitaUnica =
        await provider.loadVisitaUnica(provider, widget.event.codigo);

    //Atualiaza formulário
    setState(() {
      widget.event.dataRealizada = loadedVisitaUnica![0].dataRealizada;
      widget.event.horaRealizada = loadedVisitaUnica![0].horaRealizada;
      widget.event.status = loadedVisitaUnica![0].status;
      widget.event.codFormulario = loadedVisitaUnica![0].codFormulario;
    });
    await _loadVisitas();
  }

  Future<void> _loadVisitas() async {
    var provider = Provider.of<VisitasLista>(context, listen: false);
    loadedVisitas = await provider.loadVisitas(provider);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    var visitasLista = Provider.of<VisitasLista>(context, listen: false);

    if (loadedVisitas == null) return [];
    //return loadedVisitas!
    return visitasLista.visitas
        .where((visita) =>
            (isSameDay(visita.dataPrevista, day) ||
                (visita.dataRealizada != null &&
                    isSameDay(visita.dataRealizada, day))) &&
            (visita.nomeRepresentante == _representanteSelecionado ||
                _representanteSelecionado == null ||
                _representanteSelecionado == "Todos"))
        .map((visita) => Event(
              codigo: visita.codigo,
              codigoMedico: visita.codigoMedico,
              nomeMedico: visita.nomeMedico,
              codigoRepresentante: visita.codigoRepresentante,
              nomeRepresentante: visita.nomeRepresentante,
              codigoLocalDeEntrega: visita.codigoLocalDeEntrega,
              local: visita.local,
              status: visita.status,
              dataPrevista: visita.dataPrevista,
              dataRealizada: visita.dataRealizada,
              horaPrevista: visita.horaPrevista,
              horaRealizada: visita.horaRealizada,
              nomeUsuario: visita.nomeUsuario,
              codFormulario: visita.codFormulario,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Color> gradientCoresForm = [
      Color.fromARGB(255, 76, 171, 248),
      Color.fromARGB(255, 219, 238, 253),
    ];
    double alturaMaxima = MediaQuery.of(context).size.height;
    double? widthScreen = 0;
    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;
    DateTimeFieldPickerPlatform dateTimePickerPlatform;

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
          "Gerenciar Visita",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      //drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 232, 245),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('CÓDIGO DA VISITA: ', style: styleNames),
                    Text(
                      widget.event.codigo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 53, 95),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('MÉDICO: ', style: styleNames),
                    Text(
                      widget.event.nomeMedico,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 53, 95),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('CÓDIGO DO MÉDICO: ', style: styleNames),
                    Text(
                      widget.event.codigoMedico,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('LOCAL: ', style: styleNames),
                    Text(
                      widget.event.local,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('CÓDIGO LOCAL: ', style: styleNames),
                    Text(
                      widget.event.codigoLocalDeEntrega,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromARGB(255, 185, 219, 247)),
                    child: Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Data e Hora",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'PREVISTA : ',
                              style: styleNames,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(widget.event.dataPrevista),
                              style: styleButton,
                            ),
                            Text(
                              " - ${widget.event.horaPrevista}",
                              style: styleButton,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'REALIZADA :',
                              style: styleNames,
                            ),
                            if (widget.event.dataRealizada != null)
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(widget.event.dataRealizada!),
                                style: styleButton,
                              ),
                            if (widget.event.horaRealizada!.trim().isNotEmpty)
                              Text(
                                " - ${widget.event.horaRealizada}",
                                style: styleButton,
                              ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Visita",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 185, 219, 247)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (widget.event.status == '1')
                                Row(
                                  children: [
                                    Text('Status: ', style: styleButton),
                                    const Text(
                                      'Pendente',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.circleExclamation,
                                      color: Colors.red,
                                    )
                                  ],
                                )
                              else if (widget.event.status == '2')
                                Row(
                                  children: [
                                    Text('Status: ', style: styleButton),
                                    const Text(
                                      'Concluída',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 44, 112, 46),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      FontAwesomeIcons.check,
                                      color: Color.fromARGB(255, 1, 121, 5),
                                    ),
                                  ],
                                )
                              else if (widget.event.status == '3')
                                Row(
                                  children: [
                                    Text('Status: ', style: styleButton),
                                    const Text('Remarcada',
                                        style: TextStyle(color: Colors.orange))
                                  ],
                                )
                              else if (widget.event.status == '4')
                                Row(
                                  children: [
                                    Text('Status: ', style: styleButton),
                                    const Text('Cancelada',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                label: Text(
                                  "Editar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (ctx) {
                                      return EditarAgendaCrm(
                                        event: widget.event,
                                      );
                                    }),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 153, 0),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                              TextButton.icon(
                                label: Text(
                                  "Remarcar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (ctx) {
                                  //     return EditarAgendaCrm(
                                  //       event: value[index],
                                  //     );
                                  //   }),
                                  // );
                                },
                                icon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color.fromARGB(255, 0, 17, 255),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                label: Text(
                                  "Excluir",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        'ATENÇÃO!',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                        'Confirma a exclusão da visita ?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Fecha o dialog
                                          },
                                          child: const Text("Cancelar",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 5, 0, 0))),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Provider.of<VisitasLista>(
                                              context,
                                              listen: false,
                                            ).excluirVisita(
                                                context, widget.event.codigo);
                                          },
                                          child: const Text("Confirmar",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 5, 0, 0))),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Formulário",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 185, 219, 247)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: styleButton,
                              ),
                              if (widget.event.codFormulario!.trim().isNotEmpty)
                                const Row(
                                  children: [
                                    Text(
                                      "Preenchido",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 82, 14),
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.check,
                                      color: Color.fromARGB(255, 1, 121, 5),
                                    ),
                                  ],
                                )
                              else
                                const Row(
                                  children: [
                                    Text(
                                      "Não Preenchido",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 133, 15, 15),
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.circleExclamation,
                                      color: Color.fromARGB(255, 173, 2, 2),
                                    ),
                                  ],
                                )
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                label: Text(
                                  "Inserir",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  if (widget.event.codFormulario!
                                      .trim()
                                      .isEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (ctx) {
                                        return FormularioVisitaCrm(
                                          event: widget.event,
                                        );
                                      }),
                                    ).then((_) {
                                      _loadVisitaUnica();
                                    });
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          'ATENÇÃO!',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: const Text(
                                          //'Ocorreu um arro ao tentar aprovar o pedido.Por favor entrar em contato com o suporte do sistema',
                                          'Não é possivel inserir mais de um formulário.Por favor edite ou cancele o mesmo.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              NavigatorService.instance.pop();
                                            },
                                            child: const Text("Fechar",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 5, 0, 0))),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.new_label_rounded,
                                  color: Color.fromARGB(255, 0, 17, 255),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                              TextButton.icon(
                                label: Text(
                                  "Visualizar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (ctx) {
                                  //     return EditarAgendaCrm(
                                  //       event: value[index],
                                  //     );
                                  //   }),
                                  // );
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color.fromARGB(255, 0, 75, 56),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                              TextButton.icon(
                                label: Text(
                                  "Editar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (ctx) {
                                      return EditarFormularioVisitaCrm(
                                        event: widget.event,
                                      );
                                    }),
                                  ).then((_) {
                                    _loadVisitaUnica();
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 153, 0),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                label: Text(
                                  "Excluir",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        'ATENÇÃO!',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                        'Confirma a exclusão do formulário de visita ?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Fecha o dialog
                                          },
                                          child: const Text("Cancelar",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 5, 0, 0))),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            await Provider.of<
                                                FormularioVisitaProvider>(
                                              context,
                                              listen: false,
                                            ).excluirFormulario(context,
                                                widget.event.codFormulario);
                                            _loadVisitaUnica();
                                          },
                                          child: const Text("Confirmar",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 5, 0, 0))),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                  color: Color.fromARGB(255, 226, 0, 0),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                              TextButton.icon(
                                label: Text(
                                  "Enviar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (ctx) {
                                  //     return EditarAgendaCrm(
                                  //       event: value[index],
                                  //     );
                                  //   }),
                                  // );
                                },
                                icon: const Icon(
                                  Icons.send_outlined,
                                  color: Color.fromARGB(255, 0, 2, 122),
                                ),

                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
