import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String codigo;
  final String local;
  final String codigoLocalDeEntrega;
  String status;
  final String codigoRepresentante;
  final String nomeRepresentante;
  final String codigoMedico;
  final String nomeMedico;
  final DateTime dataPrevista;
  final DateTime? dataRealizada;
  final String horaPrevista;
  final String? horaRealizada;
  final String? nomeUsuario;

  Event({
    required this.codigo,
    required this.local,
    required this.codigoLocalDeEntrega,
    required this.status,
    required this.codigoRepresentante,
    required this.nomeRepresentante,
    required this.codigoMedico,
    required this.nomeMedico,
    required this.dataPrevista,
    required this.dataRealizada,
    required this.horaPrevista,
    required this.horaRealizada,
    required this.nomeUsuario
});

  //get nomeUsuario => null;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = {
//   for (var item in List.generate(50, (index) => index))
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
//       item % 4 + 1,
//       (index) => Event('Event $item | ${index + 1}'),
//     ),
// }..addAll({
//     kToday: [
//        Event("10:00 - Visita ao Dr. José "),
//        Event("15:00 - Visita Dr. Carlos"),
//        Event("18:00 - Hospital São Luiz Itaim "),
//     ],
//   });

// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
