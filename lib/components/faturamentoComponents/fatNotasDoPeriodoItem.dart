import 'package:flutter/material.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_notasDoPeriodo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FatNotasDoPeriodoItem extends StatelessWidget {
  const FatNotasDoPeriodoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController mycontroller = ScrollController();
    final empresa = Provider.of<FaturamentoNotasDoPeriodo>(context);
    int timestamp = int.parse(empresa.emissaoNotaFiscal
        .substring(5, empresa.emissaoNotaFiscal.length - 1));
    DateTime dateEmissao = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // var dateEmissao =
    //     DateFormat("yyyy-MM-dd").format(DateTime.parse(empresa.emissaoNotaFiscal as String));
    //final dateEmissaoFormate = DateTime.parse(dateEmissao);

    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 135, 201, 255),
                Color.fromARGB(255, 255, 255, 255),
              ]),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'NF-${empresa.notaFiscal}-${empresa.serieNotaFiscal}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 5, 34, 58),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Emissão-${DateFormat('dd/MM/yyyy', 'pt').format(dateEmissao)}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 5, 34, 58),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (empresa.serieNotaFiscal == 'A  ')
                    const Text(
                      'Tipo - Serviço Manutenção',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 34, 58),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (empresa.serieNotaFiscal == 'LOC')
                    const Text(
                      'Tipo - Locação',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 34, 58),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    const Text(
                      'Tipo - Venda',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 34, 58),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          //'Valor Total: ${valor1.toString()}',
                          empresa.razaoSocial,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          //'Valor Total: ${valor1.toString()}',
                          'Valor NF: ${empresa.valorNota}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          //'Valor Total: ${valor1.toString()}',
                          'Cond.Pgto: ${empresa.condicaoPagamento}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          //'Valor Total: ${valor1.toString()}',
                          'Cliente/Hospital: ${empresa.cliente}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
