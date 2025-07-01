import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/medicos.dart';
import 'package:pedidocompra/providers/crm/medicosLista.dart';
import 'package:pedidocompra/services/viacep_service.dart';
import 'package:provider/provider.dart';

class EditarMedicoCrm extends StatefulWidget {
  final Medicos medico;

  EditarMedicoCrm({
    Key? key,
    required this.medico,
  }) : super(key: key);

  @override
  State<EditarMedicoCrm> createState() => _EditarMedicoCrmState();
}

class _EditarMedicoCrmState extends State<EditarMedicoCrm> {
  late TextEditingController _nomeMedicoController;
  late TextEditingController _especialidadeController;
  late TextEditingController _enderecoController;
  late TextEditingController _numeroEnderecoController;
  late TextEditingController _complementoEnderecoController;
  late TextEditingController _municipioController;
  late TextEditingController _estadoController;
  late TextEditingController _bairroController;
  late TextEditingController _cepController;
  late TextEditingController _dddController;
  late TextEditingController _telefoneController;
  late TextEditingController _contatoController;
  late TextEditingController _emailController;
  late TextEditingController _crmController;
  late TextEditingController _nomeLocalController;

  final _formKey = GlobalKey<FormState>();

  late String codigoMedicoSelecionado = "";
  List<Medicos>? loadedMedicos;

  List<String> _tipoLocal = ["Consultório", "Clinica", "Hospital", "Outros"];
  String? _selectedTipoLocal;

  @override
  void initState() {
    super.initState();
    _nomeMedicoController =
        TextEditingController(text: widget.medico.nomeMedico);
    _especialidadeController =
        TextEditingController(text: widget.medico.especialidade);
    _enderecoController =
        TextEditingController(text: widget.medico.enderecoVisita);
    _numeroEnderecoController =
        TextEditingController(text: widget.medico.numeroEnderecoVisita);
    _complementoEnderecoController =
        TextEditingController(text: widget.medico.complementoEnderecoVisita);
    _municipioController = TextEditingController(text: widget.medico.municipio);
    _estadoController = TextEditingController(text: widget.medico.estado);
    _bairroController = TextEditingController(text: widget.medico.bairro);
    _cepController = TextEditingController(text: widget.medico.cep);
    _dddController = TextEditingController(text: widget.medico.ddd);
    _telefoneController = TextEditingController(text: widget.medico.telefone);
    _contatoController = TextEditingController(text: widget.medico.contato);
    _emailController = TextEditingController(text: widget.medico.email);
    _crmController = TextEditingController(text: widget.medico.crm);
    _nomeLocalController =
        TextEditingController(text: widget.medico.localDeVisita);
    _selectedTipoLocal = widget.medico.tipoLocal;

    if (_selectedTipoLocal == 'S') {
      _selectedTipoLocal = 'Consultório';
    } else if (_selectedTipoLocal == 'C') {
      _selectedTipoLocal = 'Clinica';
    } else if (_selectedTipoLocal == 'H') {
      _selectedTipoLocal = 'Hospital';
    } else {
      _selectedTipoLocal = 'Outros';
    }
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores
    _nomeMedicoController.dispose();
    _especialidadeController.dispose();
    _enderecoController.dispose();
    _complementoEnderecoController.dispose();
    _numeroEnderecoController.dispose();
    _municipioController.dispose();
    _estadoController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _dddController.dispose();
    _telefoneController.dispose();
    _contatoController.dispose();
    _emailController.dispose();
    _crmController.dispose();
    _nomeLocalController.dispose();

    super.dispose();
  }

  Future<void> _editarMedico(context) async {
    final dadosMedico = {
      'codigo': widget.medico.codigo,
      'nomeMedico': _nomeMedicoController.text,
      'especialidade': _especialidadeController.text,
      'endereco': _enderecoController.text,
      'numeroEndereco': _numeroEnderecoController.text,
      'complementoEndereco': _complementoEnderecoController.text,
      'crm': _crmController.text,
      'municipio': _municipioController.text,
      'estado': _estadoController.text,
      'bairro': _bairroController.text,
      'cep': _cepController.text,
      'ddd': _dddController.text,
      'telefone': _telefoneController.text,
      'contato': _contatoController.text,
      'email': _emailController.text,
      'tipoLocal': _selectedTipoLocal,
      'nomeLocal': _nomeLocalController.text,
    };

    await Provider.of<MedicosLista>(
      context,
      listen: false,
    ).editarMedico(context, dadosMedico);
  }

  Future<void> _loadEndereco(cep) async {
    final provider = Provider.of<ViaCepService>(context, listen: false);
    final enderecoViaCep = await provider.loadEndereco(provider, cep);

    setState(() {
      _enderecoController.text = enderecoViaCep[0].logradouro;
      _bairroController.text = enderecoViaCep[0].bairro;
      _municipioController.text = enderecoViaCep[0].localidade;
      _estadoController.text = enderecoViaCep[0].uf;
      _dddController.text = enderecoViaCep[0].ddd;
    });
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
      heightScreen = size.height * 0.8;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Editar Médico",
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
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nome",
                          hintText: "Digite o nome completo",
                          border: OutlineInputBorder()),
                      controller: _nomeMedicoController,
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
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Especialidade",
                          hintText: "Digite a especialidade",
                          border: OutlineInputBorder()),
                      controller: _especialidadeController,
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "CRM",
                                hintText: "Digite o CRM",
                                border: OutlineInputBorder()),
                            controller: _crmController,
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
                        const SizedBox(width: 10),
                        FilledButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 0, 48, 87),
                            ),
                          ),
                          onPressed: () {
                            _loadEndereco(_cepController.text);
                          },
                          child: const Text("Buscar CRM"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Tipo de Local",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedTipoLocal,
                      items: _tipoLocal.map((String tipoLocal) {
                        return DropdownMenuItem<String>(
                          value: tipoLocal,
                          child: Text(tipoLocal),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTipoLocal = newValue;
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
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nome do Local da Visita",
                          hintText: "Digite o nome do local da visita",
                          border: OutlineInputBorder()),
                      controller: _nomeLocalController,
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "CEP",
                                hintText: "Digite o CEP",
                                border: OutlineInputBorder()),
                            controller: _cepController,
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
                            keyboardType: const TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 0, 48, 87),
                            ),
                          ),
                          onPressed: () {
                            _loadEndereco(_cepController.text);
                          },
                          child: const Text("Buscar Endereço"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Endereço",
                                hintText: "Digite o endereço",
                                border: OutlineInputBorder()),
                            controller: _enderecoController,
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
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "N°",
                                hintText: "Número",
                                border: OutlineInputBorder()),
                            controller: _numeroEnderecoController,
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
                            keyboardType: const TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                     TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Complemento",
                          hintText: "Digite o complemento",
                          border: OutlineInputBorder()),
                      controller: _complementoEnderecoController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: sizeText,
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Campo Obrigatório";
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Bairro",
                          hintText: "Digite o bairro",
                          border: OutlineInputBorder()),
                      controller: _bairroController,
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 275,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Municipio",
                                hintText: "Digite o municipio",
                                border: OutlineInputBorder()),
                            controller: _municipioController,
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Estado",
                                hintText: "Digite o Estado",
                                border: OutlineInputBorder()),
                            controller: _estadoController,
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "DDD",
                                //hintText: "Digite o bairro",
                                border: OutlineInputBorder()),
                            controller: _dddController,
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Telefone",
                                //hintText: "Digite o bairro",
                                border: OutlineInputBorder()),
                            controller: _telefoneController,
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
                            keyboardType: const TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Secretária / Contato",
                          hintText: "Digite o nome do contato ",
                          border: OutlineInputBorder()),
                      controller: _contatoController,
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
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "E-mail",
                          //hintText: "Digite o nome do Contato",
                          border: OutlineInputBorder()),
                      controller: _emailController,
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
                    const SizedBox(height: 10),
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
                                _editarMedico(context);
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
            ),
          ),
        ),
      ),
    );
  }
}
