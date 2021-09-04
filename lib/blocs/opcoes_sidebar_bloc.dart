import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class OpcoesSidebarBloc extends BlocBase {
  final _sidebarController = BehaviorSubject<bool>();
  bool _detalhesDoUsuario = false;

  Stream get detalhesUsuarioAtivo => _sidebarController.stream;

  OpcoesSidebarBloc() {
    print('Instancia de OpcoesSidebarBloc criada');
  }

  void trocarCorpo() {
    _detalhesDoUsuario = !_detalhesDoUsuario;
    _sidebarController.sink.add(_detalhesDoUsuario);
  }

  @override
  void dispose() {
    _sidebarController.close();
    super.dispose();
  }
}
