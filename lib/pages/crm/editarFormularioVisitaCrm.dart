import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pedidocompra/components/crm/utils.dart';
import 'package:pedidocompra/main.dart';
import 'package:pedidocompra/models/crm/concorrentes.dart';
import 'package:pedidocompra/models/crm/formularioVisita.dart';
import 'package:pedidocompra/models/crm/hospitais.dart';
import 'package:pedidocompra/models/crm/visitas.dart';
import 'package:pedidocompra/providers/crm/HospitaisLista.dart';
import 'package:pedidocompra/providers/crm/concorrentesLista.dart';
import 'package:pedidocompra/providers/crm/formularioVisitaProvider.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EditarFormularioVisitaCrm extends StatefulWidget {
  final Event event;

  EditarFormularioVisitaCrm({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EditarFormularioVisitaCrm> createState() =>
      _EditarFormularioVisitaCrmState();
}

class _EditarFormularioVisitaCrmState extends State<EditarFormularioVisitaCrm> {
  var _proximosPassos = TextEditingController();
  var _assuntosAbordados = TextEditingController();
  late String codigoMedicoSelecionado = "";
  late String codigoLocalDeEntregaSelecionado = "";
  final format = DateFormat("dd MMM yyyy HH:mm", "pt_BR");
  final PageController _pageController = PageController();

  String selectedOption = '';
  String selectedOptionCliente = '';
  String selectedOptionEspecialidade = '';

  DateTime? dataSelecionada = DateTime.now();
  TimeOfDay? horaSelecionada = TimeOfDay.fromDateTime(DateTime.now());

  List<Visitas>? loadedVisitas;
  List<Visitas>? loadedVisitaUnica;
  String? _representanteSelecionado;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ValueNotifier<List<Event>> _selectedEvents;

  List<Concorrentes> concorrentes = [];
  List<FormularioVisita> formulario = [];
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

  TextStyle arraste = const TextStyle(fontWeight: FontWeight.bold);

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
    _loadFormulario(widget.event.codFormulario);
    _loadHospitais();
    _loadConcorrentes();
    
  }

  Future<void> _loadConcorrentes() async {
    final provider = Provider.of<ConcorrentesLista>(context, listen: false);
    concorrentes = await provider.loadConcorrentes(provider);
    setState(() {
      filteredConcorrentes = concorrentes;
    });
  }

  Future<void> _loadHospitais() async {
    final providerHospitais = Provider.of<HospitaisLista>(context, listen: false);
    hospitais = await providerHospitais.loadHospitais(providerHospitais);
    setState(() {
      filteredHospitais = hospitais;
    });
  }

  Future<void> _loadFormulario(codigoFormulario) async {
    final provider =
        Provider.of<FormularioVisitaProvider>(context, listen: false);
    formulario = await provider.getFormulario(provider, codigoFormulario);
    setState(() {
      // Atualiza data e hora selecionada

      dataSelecionada = formulario.isNotEmpty ? formulario[0].dataVisita : null;
      horaSelecionada = formulario.isNotEmpty
          ? TimeOfDay.fromDateTime(
              DateFormat("HH:mm").parse(formulario[0].horaVisita))
          : null;

      widget.event.horaRealizada =
          formulario.isNotEmpty ? formulario[0].horaVisita : "";
      // Atualizao a Parte da Avaliação
      if (formulario[0].avaliacao == "1") {
        selectedOption = "Excelente";
      } else if (formulario[0].avaliacao == "2") {
        selectedOption = "Boa";
      } else if (formulario[0].avaliacao == "3") {
        selectedOption = "Regular";
      } else if (formulario[0].avaliacao == "4") {
        selectedOption = "Ruim";
      }

      // Atualizao a Parte da lista de hospitais que o médico atende
      selectedConcorrentes = formulario[0].listaConcorrentes.split(';');
      selectedItemsController =
          TextEditingController(text: formulario[0].listaHospitais);

      // Atualiza se o médico já é cliente do  Grupo Abduch
      if (formulario[0].clienteDoGrupo == "S") {
        selectedOptionCliente = "Sim";
      } else {
        selectedOptionCliente = "Nao";
      }

      // Atualizao a Parte da lista de concorrentes que o médico utiliza
      selectedHospitais = formulario[0].listaHospitais.split(';');
      selectedItemsControllerConcorrentes =
          TextEditingController(text: formulario[0].listaConcorrentes);

      // Atualiza especialidade
      selectedOptionEspecialidade = formulario[0].especialidade;

      // Atualiza proximos passos:
      if (formulario[0].proximosPassos.isNotEmpty) {
        _proximosPassos =
            TextEditingController(text: formulario[0].proximosPassos);
      }

       // Atualiza assuntos abordados:
      if (formulario[0].assuntosAbordados.isNotEmpty) {
        _assuntosAbordados =
            TextEditingController(text: formulario[0].assuntosAbordados);
      }
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

  // Future<void> _loadVisitas() async {
  //   var provider  = Provider.of<VisitasLista>(context, listen: false);
  //   loadedVisitas = await provider.loadVisitas(provider);

  //   _selectedDay = _focusedDay;
  //   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

  // }

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
              objetivo: visita.objetivo,
              cancelarMotivo: visita.cancelarMotivo ?? "",
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

  Future<void> editarFormulario(context) async {
    final dadosFormulario = {
      'codigoFormulario': widget.event.codFormulario,
      'codigoVisita': widget.event.codigo,
      'codigoMedico': widget.event.codigoMedico,
      'nomeMedico': widget.event.nomeMedico,
      'codigoLocal': widget.event.codigoLocalDeEntrega,
      'nomeLocal': widget.event.local,
      'dataVisita': dataSelecionada?.toIso8601String(),
      'horaVisita': horaSelecionada != null
          ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}" // Para hora
          : null,
      'avaliacao': selectedOption,
      'listaHospitais': selectedItemsController.text,
      'clienteDoGrupo': selectedOptionCliente,
      'listaConcorrentes': selectedItemsControllerConcorrentes.text,
      'especialidade': selectedOptionEspecialidade,
      'proximosPassos': _proximosPassos.text,
      'assuntosAbordados': _assuntosAbordados.text,
    };

    await Provider.of<FormularioVisitaProvider>(
      context,
      listen: false,
    ).editarFormulario(context, dadosFormulario);

    //_loadVisitas();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Color> gradientCoresForm = [
      Color.fromARGB(255, 76, 171, 248),
      Color.fromARGB(255, 219, 238, 253),
    ];
    double alturaMaxima = MediaQuery.of(context).size.height;
    double larguraMaxima = MediaQuery.of(context).size.width;
    double metadeLargura = larguraMaxima / 2;
    double? widthScreen = 0;
    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;
    DateTimeFieldPickerPlatform dateTimePickerPlatform;

    if (size.width >= 600) {
      widthScreen = size.width * 0.4;
      heightScreen = size.width * 0.085;
      sizeText = 18;
      sizeCrossAxisCount = 4;
      sizeAspectRatio = 1.2;
    } else {
      widthScreen = size.width * 0.9;
      heightScreen = size.height * 0.085;
      sizeText = 14;
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 1.05;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Editar Formulário Visita",
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
            const SizedBox(height: 10),
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Row(
                children: [
                  Expanded(
                    child: DateTimeFormField(
                      initialValue: formulario.isNotEmpty
                          ? formulario[0].dataVisita
                          : null,
                      decoration:
                          const InputDecoration(labelText: 'Data da Visita'),
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
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DateTimeFormField(
                      initialValue: formulario.isNotEmpty
                          ? DateFormat('HH:mm').parse(formulario[0].horaVisita)
                          : null,
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                scrollBehavior: AppScrollBehavior(),
                physics: const ClampingScrollPhysics(),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Como foi a visita?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 52, 95),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                EdgeInsets.only(left: metadeLargura * 0.85),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildRadioOption('Excelente'),
                                _buildRadioOption('Boa'),
                                _buildRadioOption('Regular'),
                                _buildRadioOption('Ruim'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 184, 14, 2),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(5.0)),
                                  onPressed: () {
                                    setState(() {
                                      selectedHospitais = [];
                                      selectedItemsController.text = '';
                                    });
                                  },
                                  child: const Text(
                                    "Limpar Itens",
                                  )),
                            ],
                          ),
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
                          const SizedBox(height: 10),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
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
                            padding: EdgeInsets.only(left: metadeLargura * 0.8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildRadioOptionCliente('Sim'),
                                _buildRadioOptionCliente('Não'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 184, 14, 2),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(5.0)),
                                  onPressed: () {
                                    setState(() {
                                      selectedConcorrentes = [];
                                      selectedItemsControllerConcorrentes.text =
                                          '';
                                    });
                                  },
                                  child: const Text(
                                    "Limpar Itens",
                                  )),
                            ],
                          ),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
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
                            padding: EdgeInsets.only(left: metadeLargura * 0.6),
                            child: Column(
                              children: [
                                _buildRadioOptionEspecialidade("Urologia"),
                                _buildRadioOptionEspecialidade(
                                    "Urologia / Oncologia"),
                                _buildRadioOptionEspecialidade(
                                    "Urologia / Ginecologia"),
                                _buildRadioOptionEspecialidade("Ginecologia"),
                                _buildRadioOptionEspecialidade("Andrologia"),
                                _buildRadioOptionEspecialidade("Histeroscopia"),
                              ],
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Assuntos Abordados:',
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
                              controller: _assuntosAbordados,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sizeText,
                              ),
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                FontAwesomeIcons.handPointLeft,
                                size: 50,
                                color: Color.fromARGB(255, 0, 52, 95),
                              ),
                              SizedBox(width: 5),
                              Container(
                                  alignment: Alignment.topRight,
                                  child: Text("Arraste para o Lado",
                                      style: arraste)),
                            ],
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
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 120, 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/grupo_abduch.png'),
                                  height: 30,
                                ),
                              ),
                            ],
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
                              editarFormulario(context);
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
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    return Row(
      children: [
        Radio(
          value: label,
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value.toString();
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOptionCliente(String label) {
    return Row(
      children: [
        Radio(
          value: label,
          groupValue: selectedOptionCliente,
          onChanged: (value) {
            setState(() {
              selectedOptionCliente = value.toString();
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOptionEspecialidade(String label) {
    return Row(
      children: [
        Radio(
          value: label,
          groupValue: selectedOptionEspecialidade,
          onChanged: (value) {
            setState(() {
              selectedOptionEspecialidade = value.toString();
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
