import 'package:flutter/material.dart';
import 'package:pedidocompra/models/crm/contatos.dart';
import 'package:pedidocompra/providers/crm/ContatosLista.dart';
import 'package:pedidocompra/providers/crm/visitasLista.dart';
import 'package:provider/provider.dart';

class EmailFilterModal extends StatefulWidget {
  final Map<String, dynamic> dadosRelatorio;


  const EmailFilterModal({Key? key, required this.dadosRelatorio}) : super(key: key);

  @override
  _EmailFilterModalState createState() => _EmailFilterModalState();
}

class _EmailFilterModalState extends State<EmailFilterModal> {
  List<Contatos> filteredContatos = [];
  final TextEditingController emailController = TextEditingController();
  List<String> selectedEmails = [];
  TextEditingController selectedEmailsController = TextEditingController(); 
  DateTime? dataInicioSelecionada;
  DateTime? dataFimSelecionada;
  List<Contatos> contatos = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadContatos());
  }

  void filterEmails(String queryEmails) {
    setState(() {
      if (queryEmails.isEmpty) {
        filteredContatos = contatos;
      } else {
        filteredContatos = contatos
            .where((contato) =>
                contato.email.toLowerCase().contains(queryEmails.toLowerCase()))
            .toList();
      }
    });
  }

  void addToEmailsList(String selectedEmail) {
    if (!selectedEmails.contains(selectedEmail)) {
      setState(() {
        // Adiciona o item selecionado se ainda não estiver na lista
        selectedEmails.add(selectedEmail);

        // Atualiza o TextField com os itens selecionados separados por ponto e virgula
        selectedEmailsController.text = selectedEmails.join('; ');

        emailController.text = '';
      });
    } else {
      // Exibe um aviso se o item já estiver selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail "$selectedEmail" já foi adicionado!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _enviarRelatorioEmail(context) async {
    final List <dynamic> dadosEmail = [
      widget.dadosRelatorio['tipoRelatorio'],
      selectedEmailsController.text,
      widget.dadosRelatorio['dataInicio'],
      widget.dadosRelatorio['dataFim'],
    ];
    await Provider.of<VisitasLista>(
      context,
      listen: false,
    ).enviarEmailRelatorio(context, dadosEmail);
  }

  Future<void> _loadContatos() async {
    //print(Provider.of<ContatosLista>(context, listen: false));

    final provider = Provider.of<ContatosLista>(context, listen: false);
    contatos = await provider.loadContatos(provider);

    setState(() {
      filteredContatos = contatos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            onChanged: filterEmails,
            decoration: InputDecoration(
              labelText: 'Pesquisar',
              hintText: 'Digite para filtrar opções',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContatos.length,
              itemBuilder: (context, index) {
                return Container(
                  color: const Color.fromARGB(255, 155, 205, 247),
                  child: ListTile(
                    title: Text("${filteredContatos[index].nome} - ${filteredContatos[index].email}"),
                    onTap: () {
                      // Ação ao clicar em uma opção
                      addToEmailsList(filteredContatos[index].email);
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
                      backgroundColor: const Color.fromARGB(255, 184, 14, 2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(5.0)),
                  onPressed: () {
                    setState(() {
                      selectedEmails = [];
                      selectedEmailsController.text = '';
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
              controller: selectedEmailsController,
              readOnly: true, // Campo apenas de leitura
              decoration: InputDecoration(
                labelText: 'E-mails Selecionados',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 3.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 3.0), // Quando está focado
                ),
                contentPadding:
                    const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 15.0),
              ),
              maxLines: 5,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 199, 28, 16),
                    foregroundColor: Colors.white),
                child: const Text('Enviar'),
                onPressed: () => _enviarRelatorioEmail(context),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 66, 119),
                    foregroundColor: Colors.white),
                child: const Text('Fechar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}
