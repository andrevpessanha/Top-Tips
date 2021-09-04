import 'package:ad_catalog/blocs/produtos_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class CategoriasBloc extends BlocBase {
  final _categoriasController =
      BehaviorSubject<List<Map<String, bool>>>();
  final _colecaoCategorias = Firestore.instance.collection("categorias");

  List<Map<String, bool>> _categorias = [];
  List<String> _filtrosAtivos = [];

  get obterCategorias => _categoriasController.stream;

  CategoriasBloc() {
    print('Instancia de CategoriasBloc criada');
  }

  alternarFiltros(filtro) {
    if (_filtrosAtivos.contains(filtro)) {
      _filtrosAtivos.remove(filtro);
    } else {
      _filtrosAtivos.add(filtro);
    }
    BlocProvider.getBloc<ProdutosBloc>()
        .adicionarFiltros('categoria', _filtrosAtivos);
    atualizarLista();
  }

  atualizarLista() {
    _colecaoCategorias
        .orderBy('clicks', descending: true)
        .getDocuments()
        .then(_criarLista)
        .whenComplete(_enviarLista);
  }

  _criarLista(QuerySnapshot qs) {
    _categorias = _filtrosAtivos.map((filtro) => {filtro: true}).toList();
    qs.documents.forEach((ds) {
      if (!_filtrosAtivos.contains(ds.documentID)) {
        _categorias.add({ds.documentID: false});
      }
    });
  }

  _enviarLista() {
    _categoriasController.sink.add(_categorias);
  }

  @override
  void dispose() {
    _categoriasController.close();
    super.dispose();
  }
}
