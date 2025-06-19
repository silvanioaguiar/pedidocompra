import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/services/viacep_service.dart';
import 'package:provider/provider.dart';

class EditarConcorrenteCrm extends StatefulWidget {
  final Concorrentes concorrente;
  // final String local;
  // final String status;
  EditarConcorrenteCrm({
    Key? key,
    required this.concorrente,
  }) : super(key: key);

  @override
  State<EditarConcorrenteCrm> createState() => _EditarConcorrenteCrmState();
}

class _EditarConcorrenteCrmState extends State<EditarConcorrenteCrm> {
  late TextEditingController _razaoSocialController;
  late TextEditingController _nomeFantasiaController;
  late TextEditingController _enderecoController;
  late TextEditingController _municipioController;
  late TextEditingController _estadoController;
  late TextEditingController _bairroController;
  late TextEditingController _cepController;
  late TextEditingController _dddController;
  late TextEditingController _telefoneController;
  late TextEditingController _contatoController;
  late TextEditingController _homePageController;

  final _formKey = GlobalKey<FormState>();

  late String codigoConcorrenteSelecionado = "";
  List<Concorrentes>? loadedConcorrentes;

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores
    _razaoSocialController =
        TextEditingController(text: widget.concorrente.razaoSocial);
    _nomeFantasiaController =
        TextEditingController(text: widget.concorrente.nomeFantasia);
    _enderecoController =
        TextEditingController(text: widget.concorrente.endereco);
    _municipioController =
        TextEditingController(text: widget.concorrente.municipio);
    _estadoController = TextEditingController(text: widget.concorrente.estado);
    _bairroController = TextEditingController(text: widget.concorrente.bairro);
    _cepController = TextEditingController(text: widget.concorrente.cep);
    _dddController = TextEditingController(text: widget.concorrente.ddd);
    _telefoneController =
        TextEditingController(text: widget.concorrente.telefone);
    _contatoController =
        TextEditingController(text: widget.concorrente.contato);
    _homePageController =
        TextEditingController(text: widget.concorrente.homePage);
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores
    _razaoSocialController.dispose();
    _nomeFantasiaController.dispose();
    _enderecoController.dispose();
    _municipioController.dispose();
    _estadoController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _dddController.dispose();
    _telefoneController.dispose();
    _contatoController.dispose();
    _homePageController.dispose();

    super.dispose();
  }

  Future<void> _editarConcorrente(context) async {
    final dadosConcorrente = {
      'codigo': widget.concorrente.codigo,
      'razaoSocial': _razaoSocialController.text,
      'nomeFantasia': _nomeFantasiaController.text,
      'endereco': _enderecoController.text,
      'municipio': _municipioController.text,
      'estado': _estadoController.text,
      'bairro': _bairroController.text,
      'cep': _cepController.text,
      'ddd': _dddController.text,
      'telefone': _telefoneController.text,
      'contato': _contatoController.text,
      'homePage': _homePageController.text,
    };

    await Provider.of<ConcorrentesLista>(
      context,
      listen: false,
    ).editarConcorrente(context, dadosConcorrente);
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
          "Editar Concorrente",
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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (loadedConcorrentes == null ||
                        loadedConcorrentes!.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    // Extrai somente os nomes dos médicos
                    final nomesConcorrentes = loadedConcorrentes!
                        .map((concorrente) => concorrente.nomeFantasia)
                        .toList();

                    if (textEditingValue.text.isEmpty) {
                      return nomesConcorrentes; // Retorna todos os nomes
                    }

                    // Filtra os nomes com base no texto digitado
                    return nomesConcorrentes.where((String nome) {
                      return nome
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    final concorrenteSelecionado = loadedConcorrentes!
                        .firstWhere((concorrente) =>
                            concorrente.nomeFantasia == selection);

                    setState(() {
                      codigoConcorrenteSelecionado =
                          concorrenteSelecionado.codigo;
                      _nomeFantasiaController.text = selection;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Concorrente Selecionado: $selection')),
                    );
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    if (codigoConcorrenteSelecionado.isEmpty) {
                      fieldTextEditingController.text =
                          widget.concorrente.nomeFantasia;
                    }
                    return TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Razão Social",
                          hintText: "Digite a Razão Social",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (codigoConcorrenteSelecionado.isEmpty)
                      Text(
                          'Código do Concorrente: ${widget.concorrente.codigo}')
                    else
                      Text(
                          'Código do Concorrente: $codigoConcorrenteSelecionado')
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Nome Fantasia",
                      hintText: "Digite o nome Fantasia",
                      border: OutlineInputBorder()),
                  controller: _nomeFantasiaController,
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
                TextFormField(
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
                      labelText: "Contato",
                      hintText: "Digite o nome do Contato",
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
                      labelText: "Home Page",
                      //hintText: "Digite o nome do Contato",
                      border: OutlineInputBorder()),
                  controller: _homePageController,
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
                            _editarConcorrente(context);
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
    );
  }
}
