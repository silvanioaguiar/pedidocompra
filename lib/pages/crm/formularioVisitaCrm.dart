import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/hospitais.dart';
import 'package:pedidocompra/providers/crm/HospitaisLista.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/providers/crm/formularioVisitaProvider.dart';
import 'package:provider/provider.dart';

class FormularioVisitaCrm extends StatefulWidget {
  final Event event;

  FormularioVisitaCrm({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<FormularioVisitaCrm> createState() => _FormularioVisitaCrmState();
}

class _FormularioVisitaCrmState extends State<FormularioVisitaCrm> {
  late final _focoMedico = TextEditingController();
  late final _proximosPassos = TextEditingController();
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  String _selectedOption = 'Boa';
  String _selectedOptionCliente = 'Sim';

  DateTime? dataSelecionada = DateTime.now();
  TimeOfDay? horaSelecionada = TimeOfDay.fromDateTime(DateTime.now());

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

  // @override
  // void initState() {
  //   super.initState();
  //   // Inicialmente exibe todas as opções
  //   filteredOptions = allOptions;
  //   filteredConcorrentes = allConcorrentes;
  // }

  @override
  void initState() {
    super.initState();
    _loadConcorrentes();
    _loadHospitais();
  }

  Future<void> _loadConcorrentes() async {
    final provider = Provider.of<ConcorrentesLista>(context, listen: false);
    concorrentes = await provider.loadConcorrentes(provider);
    setState(() {
      filteredConcorrentes = concorrentes;
    });
  }

  Future<void> _loadHospitais() async {
    final provider = Provider.of<HospitaisLista>(context, listen: false);
    hospitais = await provider.loadHospitais(provider);
    setState(() {
      filteredHospitais = hospitais;
    });
  }

  void filterHospitais(String queryHospitais) {
    setState(() {
      if (queryHospitais.isEmpty) {
        filteredHospitais = hospitais;
      } else {
        filteredHospitais = hospitais
            .where((hospital) => hospital.nomeHospital
                .toLowerCase()
                .contains(queryHospitais.toLowerCase()))
            .toList();
      }
    });
  }

  void filterConcorrentes(String queryConcorrentes) {
    setState(() {
      if (queryConcorrentes.isEmpty) {
        //filteredConcorrentes = allConcorrentes;
        filteredConcorrentes = concorrentes;
      } else {
        filteredConcorrentes = concorrentes
            .where((concorrente) => concorrente.nomeFantasia
                .toLowerCase()
                .contains(queryConcorrentes.toLowerCase()))
            .toList();
      }
    });
  }

  void addToField(String selectedItem) {
    if (!selectedHospitais.contains(selectedItem)) {
      setState(() {
        // Adiciona o item selecionado se ainda não estiver na lista
        selectedHospitais.add(selectedItem);

        // Atualiza o TextField com os itens selecionados separados por ponto e virgula
        selectedItemsController.text = selectedHospitais.join('; ');
      });
    } else {
      // Exibe um aviso se o item já estiver selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O hospital "$selectedItem" já foi adicionado!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void addToConcorrente(String selectedConcorrente) {
    if (!selectedConcorrentes.contains(selectedConcorrente)) {
      setState(() {
        // Adiciona o item selecionado se ainda não estiver na lista
        selectedConcorrentes.add(selectedConcorrente);

        // Atualiza o TextField com os itens selecionados separados por ponto e virgula
        selectedItemsControllerConcorrentes.text =
            selectedConcorrentes.join('; ');
      });
    } else {
      // Exibe um aviso se o item já estiver selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O hospital "$selectedConcorrente" já foi adicionado!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> incluirFormulario(context) async {
    final dadosFormulario = {
      'codigoVisita': widget.event.codigo,
      'codigoMedico': widget.event.codigoMedico,
      'nomeMedico': widget.event.nomeMedico,
      'codigoLocal': widget.event.codigoLocalDeEntrega,
      'nomeLocal': widget.event.local,
      'dataVisita': dataSelecionada?.toIso8601String(),
      'horaVisita': horaSelecionada != null
          ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}" // Para hora
          : null,
      'avaliacao': _selectedOption,
      'listaHospitais': selectedItemsController.text,
      'clienteDoGrupo': _selectedOptionCliente,
      'listaConcorrentes': selectedItemsControllerConcorrentes.text,
      'especialidade': _focoMedico.text,
      'proximosPassos': _proximosPassos.text,
    };

    await Provider.of<FormularioVisitaProvider>(
      context,
      listen: false,
    ).incluirFormulario(context, dadosFormulario);
  }

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
          "Formulário Visita",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'CÓDIGO DA VISITA: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 8, 8),
                  ),
                ),
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
                const Text(
                  'MÉDICO: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 8, 8),
                  ),
                ),
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
                const Text(
                  'CÓDIGO DO MÉDICO: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 8, 8),
                  ),
                ),
                Text(
                  widget.event.codigoMedico,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'LOCAL: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 8, 8),
                  ),
                ),
                Text(
                  widget.event.local,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'CÓDIGO LOCAL: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 8, 8),
                  ),
                ),
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

            Row(
              children: [
                Expanded(
                  child: DateTimeFormField(
                    initialValue: DateTime.now(),
                    decoration:
                        const InputDecoration(labelText: 'Data da Visita'),
                    mode: DateTimeFieldPickerMode.date,
                    pickerPlatform: DateTimeFieldPickerPlatform.material,
                    materialDatePickerOptions: const MaterialDatePickerOptions(
                        locale: Locale("pt", "BR")),
                    dateFormat: DateFormat("dd MMM yyyy", 'pt_BR'),
                    onChanged: (DateTime? novaData) {
                      setState(() {
                        dataSelecionada = novaData;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DateTimeFormField(
                    initialValue: DateTime.now(),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Como foi a visita?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Excelente',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Excelente',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Boa',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Boa',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Regular',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Regular',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Ruim',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Ruim',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value!;
                                    });
                                  },
                                ),
                              ],
                            ),

                            // child: TextFormField(
                            //   decoration: const InputDecoration(
                            //       //labelText: "Digite Aqui",
                            //       hintText: "Digite aqui",
                            //       border: OutlineInputBorder(),
                            //       contentPadding: EdgeInsets.fromLTRB(
                            //           10.0, 20.0, 10.0, 20.0)),
                            //   maxLength: 254,
                            //   maxLines: 5,
                            //   controller: _comoFoiAvisita,
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: sizeText,
                            //   ),
                            // ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Quais hospitais que o médico opera ?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: searchController,
                              onChanged: filterHospitais,
                              decoration: InputDecoration(
                                labelText: 'Pesquisar',
                                hintText: 'Digite para filtrar opções',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 3.0), // Quando está focado
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: filteredHospitais.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 55, 157, 240),
                                  child: ListTile(
                                    title: Text(
                                        filteredHospitais[index].nomeHospital),
                                    onTap: () {
                                      // Ação ao clicar em uma opção
                                      addToField(filteredHospitais[index]
                                          .nomeHospital);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: selectedItemsController,
                              readOnly: true, // Campo apenas de leitura
                              decoration: InputDecoration(
                                labelText: 'Itens Selecionados',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 3.0), // Quando está focado
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 2.0),
                              ),
                              maxLines: 5,
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     decoration: const InputDecoration(
                          //         //labelText: "Digite Aqui",
                          //         hintText: "Digite aqui",
                          //         border: OutlineInputBorder(),
                          //         contentPadding: EdgeInsets.fromLTRB(
                          //             10.0, 20.0, 10.0, 20.0)),
                          //     maxLength: 254,
                          //     maxLines: 5,
                          //     controller: _hospitaisOpera,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: sizeText,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Já é cliente do Grupo Abduch ?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Sim',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Sim',
                                  groupValue: _selectedOptionCliente,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOptionCliente = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  fillColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  title: Text(
                                    'Não',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  value: 'Nao',
                                  groupValue: _selectedOptionCliente,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOptionCliente = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     decoration: const InputDecoration(
                          //         //labelText: "Digite Aqui",
                          //         hintText: "Digite aqui",
                          //         border: OutlineInputBorder(),
                          //         contentPadding: EdgeInsets.fromLTRB(
                          //             10.0, 20.0, 10.0, 20.0)),
                          //     maxLength: 254,
                          //     maxLines: 5,
                          //     controller: _jaEcliente,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: sizeText,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Empresas concorrentes:',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     decoration: const InputDecoration(
                          //         //labelText: "Digite Aqui",
                          //         hintText: "Digite aqui",
                          //         border: OutlineInputBorder(),
                          //         contentPadding: EdgeInsets.fromLTRB(
                          //             10.0, 20.0, 10.0, 20.0)),
                          //     maxLength: 254,
                          //     maxLines: 5,
                          //     controller: _empresasConcorrentes,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: sizeText,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: searchControllerConcorrentes,
                              onChanged: filterConcorrentes,
                              decoration: InputDecoration(
                                labelText: 'Pesquisar',
                                hintText: 'Digite para filtrar opções',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 3.0), // Quando está focado
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              //itemCount: filteredConcorrentes.length,
                              itemCount: filteredConcorrentes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 55, 157, 240),
                                  child: ListTile(
                                    title: Text(filteredConcorrentes[index]
                                        .nomeFantasia),
                                    onTap: () {
                                      // Ação ao clicar em uma opção
                                      addToConcorrente(
                                          filteredConcorrentes[index]
                                              .nomeFantasia);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: selectedItemsControllerConcorrentes,
                              readOnly: true, // Campo apenas de leitura
                              decoration: InputDecoration(
                                labelText: 'Itens Selecionados',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 3.0), // Quando está focado
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 2.0),
                              ),
                              maxLines: 5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Qual o foco do médico dentro da especialidade ?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  //labelText: "Digite Aqui",
                                  hintText: "Digite aqui",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 20.0)),
                              maxLength: 254,
                              maxLines: 5,
                              controller: _focoMedico,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sizeText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Próximos Passos:',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  //labelText: "Digite Aqui",
                                  hintText: "Digite aqui",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 20.0)),
                              maxLength: 254,
                              maxLines: 5,
                              controller: _proximosPassos,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sizeText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 280),
                            child: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 50,
                              color: Color.fromARGB(255, 0, 52, 95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: alturaMaxima,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: gradientCoresForm,
                      )),
                      //color: const Color.fromARGB(255, 213, 232, 248),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 200, 5),
                            child: Image(
                              image:
                                  AssetImage('assets/images/grupo_abduch.png'),
                              height: 30,
                            ),
                          ),
                          const SizedBox(height: 100),
                          const Text(
                            'Obrigado !',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          FilledButton(
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color.fromARGB(255, 0, 48, 87),
                                ),
                                minimumSize:
                                    WidgetStatePropertyAll(Size(200, 50))),
                            onPressed: () {
                              incluirFormulario(context);
                            },
                            child: const Text(
                              "Salvar",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: FilledButton(
            //     style: const ButtonStyle(
            //       backgroundColor: WidgetStatePropertyAll(
            //         Color.fromARGB(255, 0, 48, 87),
            //       ),
            //     ),
            //     onPressed: () {},
            //     child: const Text("Salvar"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
