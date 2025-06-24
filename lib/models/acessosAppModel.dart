import 'package:flutter/material.dart';

class AcessosAppModel with ChangeNotifier {
  String acessoCrm;
  String acessoCompras;  

  AcessosAppModel({

    required this.acessoCrm,
    required this.acessoCompras,

  });
}
