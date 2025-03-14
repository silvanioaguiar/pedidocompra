import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/models/crm/visitasLista.dart';
import 'package:pedidocompra/pages/crm/editarAgendaCrm.dart';
import 'package:pedidocompra/pages/crm/formularioVisitaCrm.dart';
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
  late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Visitas>? loadedVisitas;
  

  @override
  void initState() {
    super.initState();
    _loadVisitas();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  
  Future<void> _loadVisitas() async {
    final provider = Provider.of<VisitasLista>(context, listen: false);
    loadedVisitas = await provider.loadVisitas(provider);
    setState(() {

    }); // Atualize a interface do usuário após carregar as visitas
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // List<Event> _getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return kEvents[day] ?? [];
  // }

  List<Event> _getEventsForDay(DateTime day) {
    if (loadedVisitas == null) return [];
    return loadedVisitas!
        .where((visita) =>
            isSameDay(visita.dataPrevista, day) ||
            (visita.dataRealizada != null && isSameDay(visita.dataRealizada, day)))
        .map((visita) => Event(
            title: visita.local,
            description: visita.status))
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

  @override
  Widget build(BuildContext context) {

    //final provider = Provider.of<VisitasLista>(context);
    //final List<Visitas> loadedVisitas = provider.visitas;
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
      body: Column(
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
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
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
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                          subtitle: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Local:'),
                              Text('Status:'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (ctx) {
                                      return EditarAgendaCrm(
                                          event: value[index]);
                                    }),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 153, 0),
                                ),
                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (ctx) {
                                      return FormularioVisitaCrm(
                                          event: value[index]);
                                    }),
                                  );
                                },
                                icon: const Icon(
                                  Icons.file_open_sharp,
                                  color: Color.fromARGB(255, 1, 49, 88),
                                ),
                                //style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.orange))
                              ),
                            ],
                          )),
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
                        //return const MenuEmpresasFat();
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
      ),
    );
  }
}
