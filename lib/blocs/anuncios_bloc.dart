import 'dart:async';

import 'package:ad_catalog/blocs/processamento_bloc.dart';
import 'package:ad_catalog/models/anuncio.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AnunciosBloc extends BlocBase {
  final _anunciosController = BehaviorSubject<List<Anuncio>>();
  final _imagemController = PublishSubject<String>();
  final _processamentoBloc = BlocProvider.getBloc<ProcessamentoBloc>();
  final _colecaoAnuncios = Firestore.instance.collection("anuncios");

  List<Anuncio> _listaAnuncios = [];

  Stream get obterAnuncios => _anunciosController.stream;
  Stream get obterImagem => _imagemController.stream;

  AnunciosBloc() {
    print('Instancia de AnunciosBloc criada');
  }

  void especificarAnuncios(campoId, valorId) {
    print(
        'ANUNCIOS BLOC: Especificando anuncios. Campo: $campoId Valor: $valorId');
    Query query;
    if (campoId == 'idProduto') {
      query =
          _colecaoAnuncios.orderBy('valor').where(campoId, isEqualTo: valorId);
    } else {
      query = _colecaoAnuncios.where(campoId, isEqualTo: valorId);
    }
    query.getDocuments().then(_criarLista).whenComplete(_enviarLista);
  }

  void cadastrarAnuncio(anuncio) {
    final colecaoProdutos = Firestore.instance.collection("produtos");
    BlocProvider.getBloc<ProcessamentoBloc>()
        .atualizarEstadoPara('processando');

    colecaoProdutos
        .where('categoria', isEqualTo: anuncio['categoria'])
        .where('marca', isEqualTo: anuncio['marca'])
        .where('modelo', isEqualTo: anuncio['modelo'])
        .getDocuments()
        .then((qs) {
      if (qs.documents.isEmpty) {
        colecaoProdutos.add({
          'categoria': anuncio['categoria'],
          'marca': anuncio['marca'],
          'modelo': anuncio['modelo'],
          'clicks': 0
        }).then((dsProduto) {
          final colecaoCategorias = Firestore.instance.collection("categorias");
          final colecaoMarcas = Firestore.instance.collection("marcas");
          colecaoCategorias
              .document(anuncio['categoria'])
              .get()
              .then((dsCategoria) {
            if (!dsCategoria.exists) {
              dsCategoria.reference.setData({'clicks': 0});
            }
          });
          colecaoMarcas.document(anuncio['marca']).get().then((dsMarca) {
            if (!dsMarca.exists) {
              dsMarca.reference.setData({'clicks': 0});
            }
          });
          _finalizarCadastro(dsProduto.documentID, anuncio);
        });
      } else {
        _finalizarCadastro(qs.documents.first.documentID, anuncio);
      }
    });
  }

  _finalizarCadastro(idProduto, anuncio) {
    anuncio['idProduto'] = idProduto;
    _colecaoAnuncios.document().setData(anuncio).then((ds) {
      BlocProvider.getBloc<ProcessamentoBloc>()
          .atualizarEstadoPara('concluido');
    });
  }

  _criarLista(QuerySnapshot qs) {
    _listaAnuncios.clear();
    qs.documents.forEach((ds) {
      _listaAnuncios.add(Anuncio.fromJson({ds.documentID: ds.data}));
    });
  }

  _enviarLista() {
    _anunciosController.sink.add(_listaAnuncios);
  }

  void removerAnuncio(id) {
    _colecaoAnuncios.document(id).delete().then(((resultado) {
      BlocProvider.getBloc<ProcessamentoBloc>()
          .atualizarEstadoPara('concluido');
    })).catchError((onError) {
      BlocProvider.getBloc<ProcessamentoBloc>()
          .atualizarEstadoPara('concluidoComErros');
    });
  }

  void atualizarAnuncio(dados) {
    _iniciarProcessamento();
    _colecaoAnuncios
        .document(dados['id'])
        .updateData(dados)
        .then((resultado) => _concluirProcessamento())
        .catchError(_concluirComErros);
  }

  void _adicionarImagemProduto(dados) {
    Firestore.instance
        .collection("produtos")
        .document(dados['idProduto'])
        .updateData({
      'imagemUrl': dados['imagemUrl'],
      'imagemAtualizadaPor': dados['idLoja']
    });
  }

  salvarUrl(url, anuncio) {
    try {
      atualizarAnuncio({'id': anuncio.id, 'imagemUrl': url});
      _adicionarImagemProduto({
        'idProduto': anuncio.idProduto,
        'idLoja': anuncio.idLoja,
        'imagemUrl': url
      });
    } catch (erro) {
      print('ANUNCIO BLOC: Erro ao atualizar colecoes');
      _concluirComErros(erro);
    }
  }

  void _iniciarProcessamento() {
    _processamentoBloc.atualizarEstadoPara('processando');
  }

  void _concluirProcessamento() {
    _processamentoBloc.atualizarEstadoPara('concluido');
  }

  void _concluirComErros(erro) {
    print(erro);
    _processamentoBloc.atualizarEstadoPara('concluidoComErros');
  }

  @override
  void dispose() {
    _anunciosController.close();
    _imagemController.close();
    super.dispose();
  }
}
