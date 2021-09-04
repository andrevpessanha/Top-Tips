import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class LocalizationsBloc extends BlocBase {
  final _idiomaController = BehaviorSubject<String>();
  final _listaIdiomas = ['pt', 'en', 'es'];

  String _idiomaCorrente = 'pt';
  Map<String, Map<String, String>> localizedValues;

  get atualizarIdioma => _idiomaController.stream;
  List<String> get obterIdiomas => _listaIdiomas;
  String get obterIdioma => _idiomaCorrente;

  LocalizationsBloc() {
    print('Instancia de LocalizationsBloc criada');
    //_carregarValores();
  }

  void alterarIdiomaPara(novoIdioma){
    _idiomaCorrente = novoIdioma;
    _idiomaController.sink.add(novoIdioma);
  }

  @override
  void dispose() {
    _idiomaController.close();
    super.dispose();
  }
}
