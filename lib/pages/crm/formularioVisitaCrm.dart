import 'package:date_field/date_field.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class FormularioVisitaCrm extends StatefulWidget {
  final Event event;
  //final String local;
  //final String status;
  FormularioVisitaCrm({Key? key, required this.event, }) : super(key: key);

  @override
  State<FormularioVisitaCrm> createState() => _FormularioVisitaCrmState();
}

class _FormularioVisitaCrmState extends State<FormularioVisitaCrm> {
  late final _medicoController = TextEditingController();
  late final _localController = TextEditingController();
  late final _comoFoiAvisita = TextEditingController();
  late final _hospitaisOpera = TextEditingController();
  late final _jaEcliente = TextEditingController();
  late final _empresasConcorrentes = TextEditingController();
  late final _focoMedico = TextEditingController();
  late final _proximosPassos = TextEditingController();
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  String _selectedOption = 'Boa';
  String _selectedOptionCliente = 'Sim';

  List<String> allOptions = [
    'Hospital São Paulo',
    'Hospital das Clínicas',
    'Hospital Albert Einstein',
    'Hospital Sírio-Libanês',
    'Hospital Samaritano',
    'Hospital do Coração',
    'São Luiz Morumbi',
    'Santa Paula',
  ];

  List<String> allConcorrentes = [
    'Concorrente A',
    'Teste ',
    'Teste B',
    'Concorrente D',
    'Concorrente E',
    'Concorrente F',
    'Concorrente G',
    'Concorrente H',
  ];

  List<String> filteredOptions = [];
  List<String> filteredConcorrentes = [];
  List<String> selectedHospitais = [];
  List<String> selectedConcorrentes = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController selectedItemsController = TextEditingController();
  TextEditingController searchControllerConcorrentes = TextEditingController();
  TextEditingController selectedItemsControllerConcorrentes =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente exibe todas as opções
    filteredOptions = allOptions;
    filteredConcorrentes = allConcorrentes;
  }

  void filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOptions = allOptions;
      } else {
        filteredOptions = allOptions
            .where(
                (option) => option.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void filterConcorrentes(String queryConcorrentes) {
    setState(() {
      if (queryConcorrentes.isEmpty) {
        filteredConcorrentes = allConcorrentes;
      } else {
        filteredConcorrentes = allConcorrentes
            .where(
                (option) => option.toLowerCase().contains(queryConcorrentes.toLowerCase()))
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
        selectedItemsController.text =
            selectedHospitais.join('; ');
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
        selectedItemsControllerConcorrentes.text = selectedConcorrentes.join('; ');
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
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Médico",
                  hintText: "Digite o nome do médico",
                  border: OutlineInputBorder()),
              //controller: _medicoController,
              initialValue: widget.event.nomeMedico,
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
                              onChanged: filterOptions,
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
                              itemCount: filteredOptions.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 55, 157, 240),
                                  child: ListTile(
                                    title: Text(filteredOptions[index]),
                                    onTap: () {
                                      // Ação ao clicar em uma opção
                                      addToField(filteredOptions[index]);
                                      print(
                                          'Você selecionou: ${filteredOptions[index]}');
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
                              itemCount: filteredConcorrentes.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color:
                                      const Color.fromARGB(255, 55, 157, 240),
                                  child: ListTile(
                                    title: Text(filteredConcorrentes[index]),
                                    onTap: () {
                                      // Ação ao clicar em uma opção
                                      addToConcorrente(
                                          filteredConcorrentes[index]);
                                      print(
                                          'Você selecionou: ${filteredConcorrentes[index]}');
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
                            onPressed: () {},
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
