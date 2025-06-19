import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/contatos.dart';
import 'package:pedidocompra/providers/crm/ContatosLista.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/services/viacep_service.dart';
import 'package:provider/provider.dart';

class EditarContatoCrm extends StatefulWidget {
  final Contatos contato;
  // final String local;
  // final String status;
  const EditarContatoCrm({
    Key? key,
    required this.contato,
  }) : super(key: key);

  @override
  State<EditarContatoCrm> createState() => _EditarContatoCrmState();
}

class _EditarContatoCrmState extends State<EditarContatoCrm> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _dddController;
  late TextEditingController _celularController;

  final _formKey = GlobalKey<FormState>();

  late String codigoContatoSelecionado = "";
  List<Contatos>? loadedContatos;

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores
    _nomeController = TextEditingController(text: widget.contato.nome);
    _emailController = TextEditingController(text: widget.contato.email);
    _dddController = TextEditingController(text: widget.contato.ddd);
    _celularController = TextEditingController(text: widget.contato.celular);
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores
    _nomeController.dispose();
    _emailController.dispose();
    _dddController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  Future<void> _editarContato(context) async {
    final dadosContato = {
      'codigo': widget.contato.codigo,
      'nome': _nomeController.text,
      'ddd': _dddController.text,
      'celular': _celularController.text,
    };

    await Provider.of<ContatosLista>(
      context,
      listen: false,
    ).editarContato(context, dadosContato);
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
          "Editar Contato",
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
               TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Nome",
                      hintText: "Digite o nome",
                      border: OutlineInputBorder()),
                  controller: _nomeController,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (codigoContatoSelecionado.isEmpty)
                      Text('Código do Contato: ${widget.contato.codigo}')
                    else
                      Text('Código do Contato: $codigoContatoSelecionado')
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Digite um e-mail",
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
                            labelText: "Celular",
                            //hintText: "Digite o bairro",
                            border: OutlineInputBorder()),
                        controller: _celularController,
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
                            _editarContato(context);
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
