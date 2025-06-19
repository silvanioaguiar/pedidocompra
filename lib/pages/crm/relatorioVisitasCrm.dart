import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/models/crm/contatos.dart';
import 'package:pedidocompra/models/crm/emailFilterModal.dart';
import 'package:pedidocompra/models/crm/whatsappFilterModal.dart';
import 'package:pedidocompra/providers/crm/ContatosLista.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:pedidocompra/services/connectzap_service.dart';
import 'package:provider/provider.dart';

class RelatorioVisitasCrm extends StatefulWidget {
  const RelatorioVisitasCrm({super.key});

  @override
  State<RelatorioVisitasCrm> createState() => _RelatorioVisitasCrmState();
}

class _RelatorioVisitasCrmState extends State<RelatorioVisitasCrm> {
  List<String> selectedEmails = [];
  List<Contatos> contatos = [];
  List<Contatos> filteredContatos = [];
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final List<String> tipoRelatorio = [
    "Previstas",
    "Realizadas",
    "Nao Realizadas",    
    "Detalhado",
    "Resumo Geral",
  ];
  //final List<String> _emailsContatos = [];
  String? _selectedTipoRelatorio;
  DateTime? dataInicioSelecionada;
  DateTime? dataFimSelecionada;
  TextEditingController emailController = TextEditingController();
  TextEditingController selectedEmailsController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  List<Contatos>? loadedContatos;
  bool isLoading = true; // Indicador de carregamento

  @override
  void dispose() {
    super.dispose();
  }

  void _mostrarModal(BuildContext context, String tipo) {
    if (tipo == "email") {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          final Map<String, dynamic> dadosRelatorio = {
            "tipoRelatorio": _selectedTipoRelatorio,
            "dataInicio": dataInicioSelecionada,
            "dataFim": dataFimSelecionada,
          };
          return EmailFilterModal(dadosRelatorio: dadosRelatorio);
        },
      );
    } else if (tipo == "whatsapp") {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          final Map<String, dynamic> dadosRelatorio = {
            "tipoRelatorio": _selectedTipoRelatorio,
            "dataInicio": dataInicioSelecionada,
            "dataFim": dataFimSelecionada,
          };
          return WhatsappFilterModal(dadosRelatorio: dadosRelatorio);
        },
      );
    }
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
          "Relatório de Visitas",
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Tipo de Relatório",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedTipoRelatorio,
                    items: tipoRelatorio.map((String tipoRelatorio) {
                      return DropdownMenuItem<String>(
                        value: tipoRelatorio,
                        child: Text(tipoRelatorio),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTipoRelatorio = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo Obrigatório";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DateTimeFormField(
                          decoration:
                              const InputDecoration(labelText: 'Data Início'),
                          mode: DateTimeFieldPickerMode.date,
                          pickerPlatform: DateTimeFieldPickerPlatform.material,
                          materialDatePickerOptions:
                              const MaterialDatePickerOptions(
                                  locale: Locale("pt", "BR")),
                          dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                          onChanged: (DateTime? novaData) {
                            setState(() {
                              dataInicioSelecionada = novaData;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Campo Obrigatório";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DateTimeFormField(
                          decoration:
                              const InputDecoration(labelText: 'Data Fim'),
                          mode: DateTimeFieldPickerMode.date,
                          pickerPlatform: DateTimeFieldPickerPlatform.material,
                          materialDatePickerOptions:
                              const MaterialDatePickerOptions(
                                  locale: Locale("pt", "BR")),
                          dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                          onChanged: (DateTime? novaData) {
                            setState(() {
                              dataFimSelecionada = novaData;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Campo Obrigatório";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('Enviar por:'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 125,
                          child: FilledButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 0, 48, 87),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _mostrarModal(context, "email");
                              }
                            },
                            child: const Text("Email"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 125,
                          child: FilledButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 138, 9, 9),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _mostrarModal(context, "whatsapp");
                              }
                            },
                            child: const Text("Whatsapp"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
