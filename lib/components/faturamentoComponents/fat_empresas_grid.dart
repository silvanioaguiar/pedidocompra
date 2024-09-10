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
      var size = MediaQuery.of(context).size;
   
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

    if (size.width >= 600 && size.height >= 600) {     
      sizeCrossAxisCount = 2;
      sizeAspectRatio = 6.0; 
    } else {   
      sizeCrossAxisCount = 1;
      sizeAspectRatio = 4.0;
    }     

    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: loadedEmpresas.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedEmpresas[i],
        child: const FatEmpresaItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sizeCrossAxisCount,
        childAspectRatio: sizeAspectRatio,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
    );
  }
}
