import 'dart:async';

import 'package:ad_catalog/blocs/processamento_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/models/loja.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class LojaBloc extends BlocBase {
  final _lojaController = BehaviorSubject<Loja>();
  final _lojaUsuarioController = BehaviorSubject<Loja>();
  final _colecaoLojas = Firestore.instance.collection("lojas");

  Loja _loja;

  Stream get obterLoja => _lojaController.stream;
  Stream get obterLojaUsuario => _lojaUsuarioController.stream;

  LojaBloc() {
    print('Instancia de LojaBloc criada');
  }

  void cadastrarLoja(id, dados) {
    _colecaoLojas
        .document(id)
        .setData(dados)
        .whenComplete(() => especificarLoja(id, paraUsuario: true));
  }

  void atualizarLoja(dados) {
    _iniciarProcessamento();
    _colecaoLojas.document(dados['id']).updateData(dados).then((resultado) {
      _loja = Loja.fromJson({dados['id']: dados});
      BlocProvider.getBloc<UsuarioBloc>().atualizarLoja = _loja;
      _concluirProcessamento();
    }).catchError(_concluirComErros);
  }

  void salvarUrl(url, loja) {
    _colecaoLojas.document(loja.id).updateData({'imagemUrl': url});
  }

  void _iniciarProcessamento() {
    BlocProvider.getBloc<ProcessamentoBloc>()
        .atualizarEstadoPara('processando');
  }

  void _concluirProcessamento() {
    BlocProvider.getBloc<ProcessamentoBloc>().atualizarEstadoPara('concluido');
  }

  void _concluirComErros(erro) {
    print(erro);
    BlocProvider.getBloc<ProcessamentoBloc>()
        .atualizarEstadoPara('concluidoComErros');
  }

  void especificarLoja(idLoja, {paraUsuario = false}) {
    _colecaoLojas
        .document(idLoja)
        .get()
        .then(_criarLoja)
        .whenComplete(() => _enviarLoja(paraUsuario: paraUsuario));
  }

  void _criarLoja(DocumentSnapshot ds) {
    if (ds.exists) _loja = Loja.fromJson({ds.documentID: ds.data});
  }

  void _enviarLoja({paraUsuario = false}) {
    if (_loja == null) {
      _loja = Loja(vazia: true);
    }
    if (paraUsuario) {
      _lojaUsuarioController.sink.add(_loja);
    } else {
      _lojaController.sink.add(_loja);
    }
    _loja = null;
  }

  @override
  void dispose() {
    _lojaController.close();
    _lojaUsuarioController.close();
    super.dispose();
  }
}
