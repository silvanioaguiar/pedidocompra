import 'package:date_field/date_field.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class EditarAgendaCrm extends StatelessWidget {
  final Event event;
  EditarAgendaCrm({Key? key, required this.event}) : super(key: key);

  late final _medicoController = TextEditingController();

  late final _localController = TextEditingController();

  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          "Editar Visita",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(             
              decoration: const InputDecoration(
                  labelText: "Médico",
                  hintText: "Digite o nome do médico",
                  border: OutlineInputBorder()),
              //controller: _medicoController,
              initialValue: event.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: sizeText,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              //initialValue: Text(""),
              decoration: const InputDecoration(
                  labelText: "Local",
                  hintText: "Digite o local do evento/reunião",
                  border: OutlineInputBorder()),
              controller: _localController,
              style: TextStyle(
                color: Colors.black,
                fontSize: sizeText,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: DateTimeFormField(
                    decoration: const InputDecoration(labelText: 'Data'),
                    mode: DateTimeFieldPickerMode.date,
                    pickerPlatform: DateTimeFieldPickerPlatform.material,
                    onChanged: (DateTime? value) {},
                    materialDatePickerOptions: const MaterialDatePickerOptions(
                        locale: Locale("pt", "BR")),
                    dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DateTimeFormField(
                      decoration: const InputDecoration(labelText: 'Hora'),
                      mode: DateTimeFieldPickerMode.time,
                      pickerPlatform: DateTimeFieldPickerPlatform.material,
                      onChanged: (DateTime? value) {},
                      materialTimePickerOptions: MaterialTimePickerOptions(
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                          initialEntryMode: TimePickerEntryMode.inputOnly),
                      dateFormat: DateFormat('HH:mm', 'pt_BR')),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 0, 48, 87),
                  ),
                ),
                onPressed: () {},
                child: const Text("Salvar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
