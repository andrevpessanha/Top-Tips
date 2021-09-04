import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class ProcessamentoBloc extends BlocBase {
  final _processamentoController = BehaviorSubject<String>();
  String _estadoCorrente = 'pronto';

  Stream get obterEstado => _processamentoController.stream;

  ProcessamentoBloc() {
    print('Instancia de ProcessamentoBloc criada');
  }

  void atualizarEstadoPara(novoEstado) {
    print('PROCESSAMENTO BLOC: Atualizando estado para: ' + novoEstado);
    _estadoCorrente = novoEstado;
    _processamentoController.sink.add(_estadoCorrente);
  }

  @override
  void dispose() {
    _processamentoController.close();
    super.dispose();
  }
}
