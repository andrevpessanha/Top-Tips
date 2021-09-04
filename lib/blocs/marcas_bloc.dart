import 'package:ad_catalog/blocs/produtos_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MarcasBloc extends BlocBase {
  final _marcasController = BehaviorSubject<List<Map<String, bool>>>();
  final _colecaoMarcas = Firestore.instance.collection("marcas");

  List<Map<String, bool>> _marcas = [];
  List<String> _filtrosAtivos = [];

  get obterMarcas => _marcasController.stream;

  MarcasBloc() {
    print('Instancia de MarcasBloc criada');
  }

  void alternarFiltros(String filtro) {
    if (_filtrosAtivos.contains(filtro)) {
      _filtrosAtivos.remove(filtro);
    } else {
      _filtrosAtivos.add(filtro);
    }
    BlocProvider.getBloc<ProdutosBloc>()
        .adicionarFiltros('marca', _filtrosAtivos);
    atualizarLista();
  }

  void atualizarLista() {
    _colecaoMarcas
        .orderBy('clicks', descending: true)
        .getDocuments()
        .then(_criarLista)
        .whenComplete(_enviarLista);
  }

  void _criarLista(QuerySnapshot qs) {
    _marcas = _filtrosAtivos.map((filtro) => {filtro: true}).toList();
    qs.documents.forEach((ds) {
      if (!_filtrosAtivos.contains(ds.documentID)) {
        _marcas.add({ds.documentID: false});
      }
    });
  }

  void _enviarLista() {
    _marcasController.sink.add(_marcas);
  }

  @override
  void dispose() {
    _marcasController.close();
    super.dispose();
  }
}
