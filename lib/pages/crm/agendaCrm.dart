import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/models/crm/representantes.dart';
import 'package:pedidocompra/pages/crm/gerenciarVisitaCrm.dart';
import 'package:pedidocompra/providers/crm/representantesLista.dart';
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:pedidocompra/pages/crm/incluirAgendaCrm.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaCrm extends StatefulWidget {
  const AgendaCrm({super.key});

  @override
  State<AgendaCrm> createState() => _AgendaCrmState();
}

class _AgendaCrmState extends State<AgendaCrm> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Visitas>? loadedVisitas;
  List<Representantes>? loadedRepresentantes;
  String? _representanteSelecionado;
  late List<Event> _todosEventos = [];
  List? _eventosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _loadVisitas();
    _loadRepresentantes();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _eventosFiltrados = List.from(_todosEventos);
  }

  Future<void> _loadVisitas() async {
    final provider = Provider.of<VisitasLista>(context, listen: false);
    loadedVisitas = await provider.loadVisitas(provider);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _eventosFiltrados = List.from(_todosEventos);
  }

  Future<void> _loadRepresentantes() async {
    final provider = Provider.of<RepresentantesLista>(context, listen: false);
    loadedRepresentantes = await provider.loadRepresentantes(provider);
    loadedRepresentantes!
        .add(Representantes(codigo: "000000", nomeRepresentante: "Todos"));
  }

  void _filtrarEventos() {
    setState(() {
      if (_representanteSelecionado == null ||
          _representanteSelecionado == "Todos") {
        _eventosFiltrados = loadedVisitas;
      } else {
        _eventosFiltrados = loadedVisitas
            ?.where(
                (event) => event.nomeRepresentante == _representanteSelecionado)
            .toList();
        _selectedEvents.value = [];
        _selectedDay = DateTime.now();
      }
      // Atualizar eventos selecionados para o dia atual ou limpar se não houver eventos
      _selectedEvents.value = _getEventsForDay(_selectedDay ?? DateTime.now());
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Limpar os eventos selecionados e o estado
    setState(() {
      _selectedEvents.value = [];
      _selectedDay = null;
      _representanteSelecionado = null; // Resetar o dropdown
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final visitasLista = Provider.of<VisitasLista>(context, listen: false);

    if (loadedVisitas == null) return [];
    //return loadedVisitas!
    return visitasLista.visitas
        .where((visita) =>
            (isSameDay(visita.dataPrevista, day) && visita.dataRealizada == null  ||
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

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  // String formatUserName(String usuario) {
  //   // Divide os nomes pelo ponto
  //   List<String> parts = usuario.split('.');
  //   // Capitaliza a primeira letra de cada nome
  //   List<String> formattedParts = parts.map((part) {
  //     return part[0].toUpperCase() + part.substring(1).toLowerCase();
  //   }).toList();
  //   // Junta os nomes com um espaço
  //   return formattedParts.join(' ');
  // }

  @override
  Widget build(BuildContext context) {
    //String formattedName = formatUserName("");
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
          "Agenda",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Consumer<VisitasLista>(
        builder: (context, visitasLista, _) {
          return Column(
            children: [
              TableCalendar<Event>(
                locale: 'pt_Br',
                firstDay: DateTime(2020, 01, 01),
                lastDay: DateTime(2050, 01, 01),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    weekendDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 214, 215, 216))),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Mês Completo',
                  CalendarFormat.twoWeeks: '2 Semanas',
                  CalendarFormat.week: 'Semana',
                },
                headerStyle: HeaderStyle(
                    formatButtonDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 152, 204, 247),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    formatButtonTextStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onHeaderTapped: (focusedDay) async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: focusedDay,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _focusedDay = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    color: const Color.fromARGB(255, 152, 204, 247),
                    child: DropdownButton<String>(
                      dropdownColor: const Color.fromARGB(255, 152, 204, 247),
                      isExpanded: true,
                      iconSize: 25,
                      hint: const Text('Selecione um representante'),
                      value: _representanteSelecionado,
                      items: loadedRepresentantes?.map((representante) {
                        return DropdownMenuItem<String>(
                          value: representante.nomeRepresentante,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(representante.nomeRepresentante),
                          ),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        setState(() {
                          _representanteSelecionado = valor;
                        });
                        _filtrarEventos();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
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
                            //onTap: () => print('${value[index]}'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return GerenciarVisitaCrm(
                                      event: value[index],
                                    );
                                  },
                                ),
                              ).then((value){
                                if (value == true) {
                                  _loadVisitas();
                                }
                              });
                            },
                            title: SizedBox(
                              width: 100,
                              child: Text(
                                '${value[index].horaPrevista} - ${value[index].nomeMedico}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Local: ${value[index].local}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (value[index].status == '1')
                                  const Row(
                                    children: [
                                      Text('Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Pendente',
                                          style: TextStyle(color: Colors.blue)),
                                    ],
                                  )
                                else if (value[index].status == '2')
                                  const Row(
                                    children: [
                                      Text('Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Concluída',
                                          style: TextStyle(color: Colors.green))
                                    ],
                                  )
                                else if (value[index].status == '3')
                                  const Row(
                                    children: [
                                      Text('Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Remarcada',
                                          style:
                                              TextStyle(color: Colors.orange))
                                    ],
                                  )
                                else if (value[index].status == '4')
                                  const Row(
                                    children: [
                                      Text('Status: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Cancelada',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Resp.: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      value[index].nomeUsuario!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '+Detalhes',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // trailing: Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Flexible(
                            //       child: IconButton(
                            //         onPressed: () {
                            //           Navigator.of(context).push(
                            //             MaterialPageRoute(builder: (ctx) {
                            //               return EditarAgendaCrm(
                            //                 event: value[index],
                            //               );
                            //             }),
                            //           ).then(
                            //             (_) {
                            //               // Ações após o retorno
                            //               _loadVisitas();
                            //               setState(() {
                            //                 _selectedEvents.value = [];
                            //                 _selectedDay = null;
                            //                 _representanteSelecionado =
                            //                     null; // Reseta o filtro
                            //               });
                            //             },
                            //           );
                            //         },
                            //         icon: const Icon(
                            //           Icons.edit,
                            //           color: Color.fromARGB(255, 255, 153, 0),
                            //         ),
                            //         //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                            //       ),
                            //     ),
                            //     const SizedBox(width: 5),
                            //     IconButton(
                            //       onPressed: () {
                            //         Navigator.of(context).push(
                            //           MaterialPageRoute(builder: (ctx) {
                            //             return FormularioVisitaCrm(
                            //               event: value[index],
                            //             );
                            //           }),
                            //         ).then((_) {
                            //           _loadVisitas();
                            //           setState(() {
                            //             //value[index].status = '2';
                            //             _selectedEvents = ValueNotifier(
                            //                 _getEventsForDay(_selectedDay!));
                            //           });
                            //         });
                            //       },
                            //       icon: const Icon(
                            //         Icons.file_open_sharp,
                            //         color: Color.fromARGB(255, 1, 49, 88),
                            //       ),
                            //       //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                            //     ),
                            //   ],
                            // )),
                          ),
                        );
                      },
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
                            return const IncluirAgendaCrm();
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
          );
        },
      ),
    );
  }
}
