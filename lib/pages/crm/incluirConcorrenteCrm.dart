import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/services/viacep_service.dart';
import 'package:provider/provider.dart';

class IncluirConcorrenteCrm extends StatefulWidget {
  IncluirConcorrenteCrm({
    Key? key,
  }) : super(key: key);

  @override
  State<IncluirConcorrenteCrm> createState() => _IncluirConcorrenteCrmState();
}

class _IncluirConcorrenteCrmState extends State<IncluirConcorrenteCrm> {
  final TextEditingController _razaoSocialController = TextEditingController();
  final TextEditingController _nomeFantasiaController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _dddController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _homePageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String codigoConcorrenteSelecionado = "";
  List<Concorrentes>? loadedConcorrentes;

  Future<void> _incluirConcorrente(context) async {
    final dadosConcorrente = {
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
    ).incluirConcorrente(context, dadosConcorrente);
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
      heightScreen = size.height * 0.6;
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
          "Incluir Concorrente",
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
                          labelText: "Razão Social",
                          hintText: "Digite a Razão Social",
                          border: OutlineInputBorder()),
                      controller: _razaoSocialController,
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
                            keyboardType:
                                const TextInputType.numberWithOptions(),
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
                            keyboardType:
                                const TextInputType.numberWithOptions(),
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
                                _incluirConcorrente(context);
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
