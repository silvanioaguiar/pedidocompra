import 'package:flutter/material.dart';
import 'package:pedidocompra/components/appDrawer.dart';
import 'package:pedidocompra/main.dart';


class ClientesCrm extends StatefulWidget {
  const ClientesCrm({super.key});

  @override
  State<ClientesCrm> createState() => _ClientesCrmState();
}

class _ClientesCrmState extends State<ClientesCrm> {
 
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;

    double? heightScreen = 0;
    double? sizeText = 0;
    double sizeAspectRatio = 0;
    int sizeCrossAxisCount = 0;

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
          "Clientes",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Text("Clientes"),
      ),
    );

  }
}
