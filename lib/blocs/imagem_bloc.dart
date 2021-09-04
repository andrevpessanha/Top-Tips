import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ImagemBloc extends BlocBase {
  final _imagemController = StreamController<String>.broadcast();
  var _urlImagem;
  
  Stream get processamentoImagem => _imagemController.stream;
  String get obterUrl => _urlImagem;

  ImagemBloc() {
    print('Instancia de ImagemBloc criada');
  }

  void subirImagem(File imagem) async {
    _imagemController.sink.add('subindoImagem');
    try {
      final sts = await FirebaseStorage.instance
          .ref()
          .child(basename(imagem.path))
          .putFile(imagem)
          .onComplete;
      _urlImagem = await sts.ref.getDownloadURL();
      _imagemController.sink.add('concluido');

    } catch (erro) {
      print('IMAGEM BLOC: Erro ao subir a imagem');
      _imagemController.sink.add('concluidoComErros');
    }
  }

  @override
  void dispose() {
    _imagemController.close();
    super.dispose();
  }
}