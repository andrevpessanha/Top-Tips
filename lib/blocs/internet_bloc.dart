import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

class InternetBloc extends BlocBase {
  final _internetController = BehaviorSubject<String>();
  final _mc = MethodChannel('com.example.ad_catalog/internet');

  Stream get estadoInternet => _internetController.stream;

  InternetBloc() {
    print('Instancia de InternetBloc criada');
    _mc.setMethodCallHandler(_atualizarEstadoInternet);
  }

  void solicitarEstado(){
    _mc.invokeMethod('obter');
  }

  Future _atualizarEstadoInternet(MethodCall mensagem) async {
    print("FUTURE DO NET BLOC");
    print("Mensagem: " + mensagem.arguments);
    _internetController.sink.add(mensagem.arguments);
  }

  @override
  void dispose() {
    _internetController.close();
    super.dispose();
  }
} 