import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/locaisDeEntrega.dart';
import 'package:pedidocompra/providers/crm/locaisDeEntregaLista.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/providers/crm/medicosLista.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:provider/provider.dart';

class IncluirAgendaCrm extends StatefulWidget {
  const IncluirAgendaCrm({super.key});

  @override
  State<IncluirAgendaCrm> createState() => _IncluirAgendaCrmState();
}

class _IncluirAgendaCrmState extends State<IncluirAgendaCrm> {
  final _formKey = GlobalKey<FormState>();
  late final _medicoController = TextEditingController();
  late final _localController = TextEditingController();
  final _objetivoController = TextEditingController();
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  List<Medicos>? loadedMedicos;
  List<LocaisDeEntrega>? loadedLocaisDeEntrega;
  bool isLoading = true; // Indicador de carregamento
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";

  DateTime? dataSelecionada;
  TimeOfDay? horaSelecionada;

  // final List<String> _medicos = List.generate(
  //   1000, // Gera uma lista de 1000 médicos como exemplo
  //   (index) => 'Dr. Médico $index',
  // );

  @override
  void initState() {
    super.initState();
    _loadMedicos();
    _loadLocaisDeEntrega();
  }

  Future<void> _loadMedicos() async {
    final provider = Provider.of<MedicosLista>(context, listen: false);
    final medicos = await provider.loadMedicos(provider);

    setState(() {
      loadedMedicos = medicos;
      isLoading = false;
    });
  }

  Future<void> _loadLocaisDeEntrega() async {
    final provider = Provider.of<LocaisDeEntregaLista>(context, listen: false);
    final locaisDeEntrega = await provider.loadLocaisDeEntrega(provider);

    setState(() {
      loadedLocaisDeEntrega = locaisDeEntrega;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _medicoController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _incluirVisitas(context) async {
    final dadosVisita = {
      'codigoMedico': codigoMedicoSelecionado,
      'medico': _medicoController.text,
      'codigoLocalDeEntrega': codigoLocalDeEntregaSelecionado,
      'localDescricao': _localController.text,
      'objetivo': _objetivoController.text,
      'dataPrevista': dataSelecionada?.toIso8601String(),
      'horaPrevista': horaSelecionada != null
          ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}" // Para hora
          : null,
    };

    await Provider.of<VisitasLista>(
      context,
      listen: false,
    ).incluirVisitas(context, dadosVisita);
  }

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
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Incluir Visita",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (loadedMedicos == null || loadedMedicos!.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          // Extrai somente os nomes dos médicos
                          final nomesMedicos = loadedMedicos!
                              .map((medico) => medico.nomeMedico)
                              .toList();

                          if (textEditingValue.text.isEmpty) {
                            return nomesMedicos; // Retorna todos os nomes
                          }

                          // Filtra os nomes com base no texto digitado
                          return nomesMedicos.where((String nome) {
                            return nome
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          final medicoSelecionado = loadedMedicos!.firstWhere(
                              (medico) => medico.nomeMedico == selection);

                          setState(() {
                            codigoMedicoSelecionado = medicoSelecionado.codigo;
                            _medicoController.text = selection;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Médico Selecionado: $selection')),
                          );
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Médico",
                                hintText: "Digite o nome do médico",
                                border: OutlineInputBorder()),
                            controller: fieldTextEditingController,
                            focusNode: focusNode,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: sizeText,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo Obrigatório";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Código do Médico: $codigoMedicoSelecionado'),
                  ],
                ),
                const SizedBox(height: 20),
                Autocomplete<String>(
                  optionsBuilder:
                      (TextEditingValue textEditingLocaisDeEntrega) {
                    if (loadedLocaisDeEntrega == null ||
                        loadedLocaisDeEntrega!.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    // Extrai somente os nomes dos médicos
                    final nomesLocaisDeEntrega = loadedLocaisDeEntrega!
                        .map(
                            (locaisDeEntrega) => locaisDeEntrega.localDescricao)
                        .toList();

                    if (textEditingLocaisDeEntrega.text.isEmpty) {
                      return nomesLocaisDeEntrega; // Retorna todos os nomes
                    }

                    // Filtra os nomes com base no texto digitado
                    return nomesLocaisDeEntrega.where((String nome) {
                      return nome.toLowerCase().contains(
                          textEditingLocaisDeEntrega.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    final localDeEntregaSelecionado = loadedLocaisDeEntrega!
                        .firstWhere(
                            (local) => local.localDescricao == selection);

                    setState(() {
                      codigoLocalDeEntregaSelecionado =
                          localDeEntregaSelecionado.codigo;
                      _localController.text = selection;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Local da Visita Selecionado: $selection')),
                    );
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Local da Visita",
                          hintText: "Selecione um Local para a visita.",
                          border: OutlineInputBorder()),
                      controller: fieldTextEditingController,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: sizeText,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo Obrigatório";
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Código do Local: $codigoLocalDeEntregaSelecionado'),
                  ],
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Objetivo",
                    hintText: "Objetivo da Visita",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                  ),
                  maxLength: 254,
                  maxLines: 5,
                  controller: _objetivoController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeText,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo Obrigatório";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeFormField(
                        decoration: const InputDecoration(labelText: 'Data'),
                        mode: DateTimeFieldPickerMode.date,
                        pickerPlatform: DateTimeFieldPickerPlatform.material,
                        materialDatePickerOptions:
                            const MaterialDatePickerOptions(
                                locale: Locale("pt", "BR")),
                        dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                        onChanged: (DateTime? novaData) {
                          setState(() {
                            dataSelecionada = novaData;
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
                        decoration: const InputDecoration(labelText: 'Hora'),
                        mode: DateTimeFieldPickerMode.time,
                        pickerPlatform: DateTimeFieldPickerPlatform.material,
                        materialTimePickerOptions: MaterialTimePickerOptions(
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                            initialEntryMode: TimePickerEntryMode.inputOnly),
                        dateFormat: DateFormat('HH:mm', 'pt_BR'),
                        onChanged: (DateTime? novaHora) {
                          setState(() {
                            horaSelecionada = TimeOfDay.fromDateTime(novaHora!);
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 0, 48, 87),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _incluirVisitas(context);
                      }
                    },
                    child: const Text("Salvar"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
