import 'dart:io';
import 'dart:typed_data';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
//import 'dart:html' as html;

//import 'package:url_launcher/url_launcher.dart';

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
  final pdf = pw.Document();
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  final _formKey = GlobalKey<FormState>();

  String? _representanteSelecionado;

  DateTime? dataSelecionada = DateTime.now();
  TimeOfDay? horaSelecionada = TimeOfDay.fromDateTime(DateTime.now());

  List<String> selectedEmails = [];
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
  TextEditingController emailController = TextEditingController();
  TextEditingController selectedEmailsController = TextEditingController();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ValueNotifier<List<Event>> _selectedEvents;

  Color colorStatusPendente = Color.fromARGB(255, 133, 15, 15);

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
      widget.event.dataPrevista = loadedVisitaUnica![0].dataPrevista;
      widget.event.horaPrevista = loadedVisitaUnica![0].horaPrevista;
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

  Future<void> _editarVisitas(context) async {
    final dadosVisita = {
      'codigo': widget.event.codigo,
      'medico': widget.event.nomeMedico,
      'codigoMedico': widget.event.codigoMedico,
      'codigoLocalDeEntrega': widget.event.codigoLocalDeEntrega,
      'local': widget.event.local,
      'status': widget.event.status,
      'dataPrevista': dataSelecionada?.toIso8601String(),
      'horaPrevista': horaSelecionada != null
          ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}" // Para hora
          : null,
    };

    await Provider.of<VisitasLista>(
      context,
      listen: false,
    ).editarVisitas(context, dadosVisita);

    _loadVisitaUnica();
  }

  Future<void> _enviarFormularioEmail(context, email) async {
    final dadosFormulario = {
      'codigo': widget.event.codFormulario,
    };

    await Provider.of<FormularioVisitaProvider>(
      context,
      listen: false,
    ).enviarEmailFormulario(context, dadosFormulario, email);
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final customFont = await loadFont();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Olá, esse é seu PDF em Flutter Web!',
            style: pw.TextStyle(font: customFont),
          ),
        ),
      ),
    );
    return pdf.save();
  }

  Future<void> sharePdf() async {
    //await previewPdf();
    final pdfData = await generatePdf();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/example.pdf');
    await file.writeAsBytes(pdfData);

    final shareParams = ShareParams(
      files: [XFile(file.path)],
      text: 'Confira este PDF!',
    );

    SharePlus.instance.share(shareParams);
  }

  Future<void> previewPdf() async {
    final pdfData = await generatePdf();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  Future<pw.Font> loadFont() async {
    final fontData = await rootBundle.load(
        'assets/fonts/Arial_Regular.ttf'); // Certifique-se de ter essa fonte no seu projeto.
    return pw.Font.ttf(fontData);
  }

  void addToEmailsList(String selectedEmail) {
    if (!selectedEmails.contains(selectedEmail)) {
      setState(() {
        // Adiciona o item selecionado se ainda não estiver na lista
        selectedEmails.add(selectedEmail);

        // Atualiza o TextField com os itens selecionados separados por ponto e virgula
        selectedEmailsController.text = selectedEmails.join('; ');

        emailController.text = '';
      });
    } else {
      // Exibe um aviso se o item já estiver selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail "$selectedEmail" já foi adicionado!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Future<void> sharePdfWeb() async {
  //   final pdfData = await generatePdf();
  //   final blob = html.Blob([pdfData], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);

  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute('download', 'example.pdf')
  //     ..click();

  //   html.Url.revokeObjectUrl(url);
  // }

  // Future<String> generatePdfUrl() async {
  //   final pdfData = await generatePdf();
  //   final blob = html.Blob([pdfData], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   return url;
  // }

  // Future<void> sendPdfViaWhatsApp(String phone) async {
  //   final pdfUrl = await generatePdfUrl();
  //   final message = 'Confira este PDF: $pdfUrl';
  //   final Uri uri =
  //       Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     print('Erro ao abrir o WhatsApp');
  //   }
  // }

  // Future<void> sendPdfViaEmail(String email) async {
  //   final pdfUrl = await generatePdfUrl();

  //   html.window.open(pdfUrl, "_blank");

  //   final Uri uri = Uri.parse(
  //       'mailto:$email?subject=Seu PDF&body=Confira este PDF: $pdfUrl');

  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     print('Erro ao abrir o e-mail');
  //   }
  // }

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
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PREVISTA: ',
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'REALIZADA: ',
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
                                        color: Color.fromARGB(255, 133, 15, 15),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.circleExclamation,
                                      color: colorStatusPendente,
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
                          const SizedBox(height: 20),
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
                              const SizedBox(
                                width: 40,
                              ),
                              TextButton.icon(
                                label: Text(
                                  "Remarcar",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 400,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Remarcar Visita",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 47, 85)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            DateTimeFormField(
                                                          initialValue: widget
                                                              .event
                                                              .dataPrevista,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Data da Visita'),
                                                          mode:
                                                              DateTimeFieldPickerMode
                                                                  .date,
                                                          pickerPlatform:
                                                              DateTimeFieldPickerPlatform
                                                                  .material,
                                                          materialDatePickerOptions:
                                                              const MaterialDatePickerOptions(
                                                                  locale: Locale(
                                                                      "pt",
                                                                      "BR")),
                                                          dateFormat:
                                                              DateFormat(
                                                                  "dd MMM yyyy",
                                                                  'pt_BR'),
                                                          onChanged: (DateTime?
                                                              novaData) {
                                                            setState(() {
                                                              dataSelecionada =
                                                                  novaData;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child:
                                                            DateTimeFormField(
                                                          //initialValue: widget.event.horaPrevista,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Hora'),
                                                          mode:
                                                              DateTimeFieldPickerMode
                                                                  .time,
                                                          pickerPlatform:
                                                              DateTimeFieldPickerPlatform
                                                                  .material,
                                                          materialTimePickerOptions:
                                                              MaterialTimePickerOptions(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      Widget?
                                                                          child) {
                                                                    return MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              alwaysUse24HourFormat: true),
                                                                      child:
                                                                          child!,
                                                                    );
                                                                  },
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .inputOnly),
                                                          dateFormat:
                                                              DateFormat(
                                                                  'HH:mm',
                                                                  'pt_BR'),
                                                          onChanged: (DateTime?
                                                              novaHora) {
                                                            setState(() {
                                                              horaSelecionada =
                                                                  TimeOfDay
                                                                      .fromDateTime(
                                                                          novaHora!);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        199,
                                                                        28,
                                                                        16),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white),
                                                        child: const Text(
                                                            'Salvar'),
                                                        onPressed: () =>
                                                            _editarVisitas(
                                                                context),
                                                      ),
                                                      const SizedBox(
                                                        width: 30,
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        0,
                                                                        66,
                                                                        119),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white),
                                                        child: const Text(
                                                            'Fechar'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color.fromARGB(255, 0, 17, 255),
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
                                Row(
                                  children: [
                                    const Text(
                                      "Não Preenchido",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 133, 15, 15),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(FontAwesomeIcons.circleExclamation,
                                        color: colorStatusPendente),
                                  ],
                                )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  sharePdf();
                                  //sendPdfViaEmail("silvaniojr.sj@gmail.com");
                                  //sendPdfViaWhatsApp("5511988435119");
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
                                          onPressed: () async {
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
                                  "Enviar e-mail",
                                  style: styleButton,
                                ),
                                onPressed: () {
                                  //Enviar pdf via e-mail ou whatsapp

                                  if (widget.event.codFormulario == "      ") {
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
                                          'Função indisponivel ! O formulário ainda não foi preeenchido.',
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
                                  } else {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 400,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "Enviar E-mail",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 47, 85)),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Form(
                                                            key: _formKey,
                                                            child:
                                                                TextFormField(
                                                              decoration: const InputDecoration(
                                                                  labelText:
                                                                      "Inserir e-mail",
                                                                  hintText:
                                                                      "Digite o e-mail",
                                                                  border:
                                                                      OutlineInputBorder()),
                                                              controller:
                                                                  emailController,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    sizeText,
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "Campo Obrigatório";
                                                                }

                                                                if (!value.contains(
                                                                        "@") ||
                                                                    !value.contains(
                                                                        ".com")) {
                                                                  return "E-mail inválido";
                                                                }

                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        199,
                                                                        28,
                                                                        16),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white),
                                                            child: const Text(
                                                                'Inserir'),
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                addToEmailsList(
                                                                    emailController
                                                                        .text);
                                                              }
                                                            }),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TextField(
                                                          controller:
                                                              selectedEmailsController,
                                                          readOnly:
                                                              true, // Campo apenas de leitura
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'E-mails Selecionados',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  width: 3.0),
                                                            ),
                                                            focusedBorder:
                                                                const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width:
                                                                      3.0), // Quando está focado
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10.0,
                                                                    3.0,
                                                                    10.0,
                                                                    15.0),
                                                          ),
                                                          maxLines: 5,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      199,
                                                                      28,
                                                                      16),
                                                              foregroundColor:
                                                                  Colors.white),
                                                          child: const Text(
                                                              'Enviar'),
                                                          onPressed: () =>
                                                              _enviarFormularioEmail(
                                                                  context,
                                                                  selectedEmailsController
                                                                      .text),
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      66,
                                                                      119),
                                                              foregroundColor:
                                                                  Colors.white),
                                                          child: const Text(
                                                              'Fechar'),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }

                                  // _enviarFormularioEmail(
                                  //     context, "silvaniojr.sj@gmail.com");
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
