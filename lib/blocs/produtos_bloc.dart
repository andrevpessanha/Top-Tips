import 'dart:async';

import 'package:ad_catalog/models/produto.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProdutosBloc extends BlocBase {
  final _produtosController = BehaviorSubject<List<Produto>>();
  final _colecaoProdutos = Firestore.instance.collection("produtos");

  List<Produto> _listaProdutos = [];
  List<String> _filtrosCategoria = [];
  List<String> _filtrosMarca = [];

  Stream get obterProdutos => _produtosController.stream;

  ProdutosBloc() {
    print('Instancia de ProdutosBloc criada');
  }

  void adicionarFiltros(campo, valores) {
    if (campo == 'categoria') {
      _filtrosCategoria = valores;
    } else if (campo == 'marca') {
      _filtrosMarca = valores;
    }
    atualizarProdutos();
  }

  void atualizarProdutos() {
    _colecaoProdutos
        .orderBy('clicks', descending: true)
        .getDocuments()
        .then(_criarLista)
        .whenComplete(_enviarLista);
  }

  void _criarLista(qs) {
    _listaProdutos.clear();
    qs.documents.forEach((ds) {
      if (_filtrosCategoria.isNotEmpty || _filtrosMarca.isNotEmpty) {
        if (_filtrosCategoria.isNotEmpty && _filtrosMarca.isNotEmpty) {
          if (_filtrosCategoria.contains(ds.data['categoria']) &&
              _filtrosMarca.contains(ds.data['marca'])) {
            _listaProdutos.add(Produto.fromJson({ds.documentID: ds.data}));
          }
        } else if (_filtrosCategoria.isNotEmpty) {
          if (_filtrosCategoria.contains(ds.data['categoria'])) {
            _listaProdutos.add(Produto.fromJson({ds.documentID: ds.data}));
          }
        } else {
          if (_filtrosMarca.contains(ds.data['marca'])) {
            _listaProdutos.add(Produto.fromJson({ds.documentID: ds.data}));
          }
        }
      } else {
        _listaProdutos.add(Produto.fromJson({ds.documentID: ds.data}));
      }
    });
  }

  void _enviarLista() {
    _produtosController.sink.add(_listaProdutos);
  }

  @override
  void dispose() {
    _produtosController.close();
    super.dispose();
  }

  //_filtroController.stream.listen(consultarProdutos);
  //_categoriasController.stream.listen(print);
  //_marcasController.stream.listen(print);
  //Firestore.instance.collection("marcas").document('Gigabyte').get().then((ds){
  //  if(!ds.exists){
  //    print('Nao existe');
  //    ds.reference.setData({'clicks': 5});
  //  }
  //});
}
