import 'package:flutter/material.dart';
import 'package:pedidocompra/components/faturamentoComponents/fatEmpresaItem.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/fat_empresaLista.dart';
import 'package:pedidocompra/models/moduloFaturamentoModels/faturamento_empresas.dart';
import 'package:provider/provider.dart';

class FatEmpresasGrid extends StatelessWidget {
  const FatEmpresasGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFatEmpresas = Provider.of<FatEmpresaLista>(context);
    final List<FaturamentoEmpresas> loadedEmpresas =
        providerFatEmpresas.empresas;

    return ListView.builder(      
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedEmpresas.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(        
        value: loadedEmpresas[i],
        child: const FatEmpresaItem(),
      ),
    );
    //);
  }
}
