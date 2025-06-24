import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/locaisDeEntrega.dart';
import 'package:pedidocompra/providers/crm/locaisDeEntregaLista.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/providers/crm/medicosLista.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:provider/provider.dart';


class EditarAgendaCrm extends StatefulWidget {
  final Event event;

  EditarAgendaCrm({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EditarAgendaCrm> createState() => _EditarAgendaCrmState();
}

class _EditarAgendaCrmState extends State<EditarAgendaCrm> {
  late TextEditingController _medicoController;
  late TextEditingController _localController;
  //late TextEditingController _objetivoController;
  var _objetivoController = TextEditingController();
  var _cancelarController = TextEditingController();
  //final _objetivoController = TextEditingController();

  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  final _formKey = GlobalKey<FormState>();

  final List<String> _status = [
    '1-Pendente',
    '2-Concluída',
    '3-Remarcada',
    '4-Cancelada',
  ];
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";
  List<Medicos>? loadedMedicos;
  List<LocaisDeEntrega>? loadedLocaisDeEntrega;
  bool isLoading = true; // Indicador de carregamento
  DateTime? dataSelecionada;
  TimeOfDay? horaSelecionada;

  String statusSelecionado = '';

  @override
  void initState() {
    super.initState();
    _loadMedicos();
    _loadLocaisDeEntrega();

    // Inicializa os controladores com os valores do evento
    _medicoController = TextEditingController(text: widget.event.nomeMedico);
    _localController = TextEditingController(text: widget.event.local);
    _objetivoController = TextEditingController(text: widget.event.objetivo);
    _cancelarController = TextEditingController(text: widget.event.cancelarMotivo);

    // Inicializa o status selecionado
    if (widget.event.status == '1') {
      statusSelecionado = '1-Pendente';
    } else if (widget.event.status == '2') {
      statusSelecionado = '2-Concluída';
    } else if (widget.event.status == '3') {
      statusSelecionado = '3-Remarcada';
    } else if (widget.event.status == '4') {
      statusSelecionado = '4-Cancelada';
    }

    // Inicialiaza data e hora
    dataSelecionada = widget.event.dataPrevista;
    horaSelecionada = TimeOfDay.fromDateTime(
      DateFormat('HH:mm', 'pt_BR').parse(widget.event.horaPrevista),
    );
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores
    _medicoController.dispose();
    _localController.dispose();
    _objetivoController.dispose();
    super.dispose();
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

  Future<void> _editarVisitas(context) async {
    final dadosVisita = {
      'codigo': widget.event.codigo,
      'medico': _medicoController.text,
      'codigoMedico': codigoMedicoSelecionado,
      'codigoLocalDeEntrega': codigoLocalDeEntregaSelecionado,
      'local': _localController.text,
      'objetivo': _objetivoController.text,
      'status': statusSelecionado,
      'dataPrevista': dataSelecionada?.toIso8601String(),
      'horaPrevista': horaSelecionada != null
          ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}" // Para hora
          : null,
      'cancelarMotivo':_cancelarController.text,
    };

    await Provider.of<VisitasLista>(
      context,
      listen: false,
    ).editarVisitas(context, dadosVisita);
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
      widthScreen = size.width * 0.5;
      heightScreen = size.width * 0.8;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.9;
      heightScreen = size.height * 0.6;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    if (statusSelecionado.isEmpty) {
      if (widget.event.status == '1') {
        statusSelecionado = '1-Pendente';
      } else if (widget.event.status == '2') {
        statusSelecionado = '2-Concluída';
      } else if (widget.event.status == '3') {
        statusSelecionado = '3-Remarcada';
      } else if (widget.event.status == '4') {
        statusSelecionado = '4-Cancelada';
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Editar Visita",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      //drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: widthScreen,
                child: Column(
                  children: [
                    Autocomplete<String>(
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
                        final medicoSelecionado = loadedMedicos!
                            .firstWhere((medico) => medico.nomeMedico == selection);
                            
                        setState(() {
                          codigoMedicoSelecionado = medicoSelecionado.codigo;
                          _medicoController.text = selection;
                        });
                            
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Médico Selecionado: $selection')),
                        );
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        if (codigoMedicoSelecionado.isEmpty) {
                          fieldTextEditingController.text = widget.event.nomeMedico;
                        }
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
                        if (codigoMedicoSelecionado.isEmpty)
                          Text('Código do Médico: ${widget.event.codigoMedico}')
                        else
                          Text('Código do Médico: $codigoMedicoSelecionado')
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
                                  Text('Local de Entrega Selecionado: $selection')),
                        );
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        if (codigoLocalDeEntregaSelecionado.isEmpty) {
                          fieldTextEditingController.text = widget.event.local;
                        }
                        return TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Local",
                              hintText: "Selecione o Local da Visita",
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
                    const SizedBox(height: 05),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (codigoLocalDeEntregaSelecionado.isEmpty)
                          Text('Código Local: ${widget.event.codigoLocalDeEntrega}')
                        else
                          Text('Código Local: $codigoLocalDeEntregaSelecionado'),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    Container(
                      width: widthScreen,
                      height: heightScreen,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Status:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            dropdownColor: const Color.fromARGB(255, 152, 204, 247),
                            isExpanded: true,
                            iconSize: 25,
                            //hint: const Text('Selecione um representante'),
                            value: statusSelecionado,
                            items: _status.map((statusSelecionado) {
                              return DropdownMenuItem<String>(
                                value: statusSelecionado,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(statusSelecionado),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? valor) {
                              setState(() {
                                statusSelecionado = valor!;
                              });
                            },
                          ),
                          if (statusSelecionado == '4-Cancelada')
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Motivo do Cancelamento',
                                  border: OutlineInputBorder(),
                                ),
                                controller: _cancelarController,
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
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: DateTimeFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Data'),
                                  mode: DateTimeFieldPickerMode.date,
                                  pickerPlatform:
                                      DateTimeFieldPickerPlatform.material,
                                  materialDatePickerOptions:
                                      const MaterialDatePickerOptions(
                                          locale: Locale("pt", "BR")),
                                  dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                                  initialValue: dataSelecionada,
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
                                  decoration:
                                      const InputDecoration(labelText: 'Hora'),
                                  mode: DateTimeFieldPickerMode.time,
                                  pickerPlatform:
                                      DateTimeFieldPickerPlatform.material,
                                  materialTimePickerOptions:
                                      MaterialTimePickerOptions(
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return MediaQuery(
                                              data: MediaQuery.of(context).copyWith(
                                                  alwaysUse24HourFormat: true),
                                              child: child!,
                                            );
                                          },
                                          initialEntryMode:
                                              TimePickerEntryMode.inputOnly),
                                  dateFormat: DateFormat('HH:mm', 'pt_BR'),
                                  initialValue: DateFormat('HH:mm', 'pt_BR')
                                      .parse(widget.event.horaPrevista),
                                  onChanged: (DateTime? novaHora) {
                                    setState(() {
                                      horaSelecionada =
                                          TimeOfDay.fromDateTime(novaHora!);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                      _editarVisitas(context);
                                    }
                                  },
                                  child: const Text("Salvar"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FilledButton(
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color.fromARGB(255, 138, 9, 9),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
