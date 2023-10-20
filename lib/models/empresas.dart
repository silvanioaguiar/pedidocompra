import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pedidocompra/pages/pedidosPendentes.dart';

class Empresas with ChangeNotifier {
  
  String? _empresa; 
 

 

    String? get empresa {
    return  _empresa ;
  }

  

}
