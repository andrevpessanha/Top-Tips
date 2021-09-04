import 'package:ad_catalog/blocs/imagem_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagemWidget extends StatelessWidget {
  var estadoImagemWidget = 'concluido';
  var imagemUrl;
  final editavel;
  final avatar;
  final salvarUrl;

  ImagemWidget(
      {Key key,
      this.imagemUrl,
      this.editavel = false,
      this.avatar = false,
      this.salvarUrl})
      : super(key: key);

  String get obterUrl => imagemUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: BlocProvider.getBloc<ImagemBloc>().processamentoImagem,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == 'subindoImagem') {
            // Caso o usuario estiver subindo uma imagem
            estadoImagemWidget = 'processando';
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == 'concluido') {
            // Caso o processo de subir uma imagem tenha sido concluido
            estadoImagemWidget = 'concluido';
            imagemUrl = BlocProvider.getBloc<ImagemBloc>().obterUrl;
            salvarUrl(imagemUrl);
          } else if (snapshot.hasData && snapshot.data == 'concluidoComErros') {
            estadoImagemWidget = 'concluidoComErros';
          }

          List<Widget> lista = [
            GestureDetector(
                child: Container(
                  child: _obterImagens(context),
                ),
                onDoubleTap: () {
                  if (editavel == true) {
                    _abrirModalOpcoes(context);
                  }
                }),
          ];
          if (avatar == false) {
            lista.addAll([
              SizedBox(height: 2),
              editavel == true && avatar == false
                  ? Text('Duplo clique na imagem para alterá-la',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12))
                  : Container(),
            ]);
          }
          return Column(children: lista);
        },
      ),
    );
  }

  _obterImagens(context) {
    if (avatar == true) {
      return CircleAvatar(
        radius: 36,
        backgroundImage: imagemUrl != null
            ? NetworkImage(imagemUrl)
            : AssetImage("imagens/sem_foto.gif"),
        child: imagemUrl == null &&
                BlocProvider.getBloc<UsuarioBloc>().estaLogado() == true
            ? Text('Duplo tap para atualizar', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),)
            : Container(),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width * 8.65 / 10,
        height: MediaQuery.of(context).size.height * 4.65 / 10,
        child: imagemUrl != null
            ? Image.network(imagemUrl, fit: BoxFit.cover)
            : Image.asset("imagens/sem_foto.gif", fit: BoxFit.cover),
      );
    }
  }

  void _abrirModalOpcoes(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _criarOpcao(context, ImageSource.camera, 'Tirar Foto'),
                      Divider(height: 20, color: Theme.of(context).primaryColorLight ),
                      _criarOpcao(context, ImageSource.gallery, 'Abrir Galeria')
                    ],
                  ),
                );
              });
        });
  }

  _criarOpcao(context, imageSource, label) {
    return FlatButton(
        child: Text(label, style: TextStyle(color: Theme.of(context).primaryColorLight ,fontSize: 20.0)),
        onPressed: () {
          Navigator.pop(context);
          ImagePicker.pickImage(source: imageSource, maxWidth: 1920)
              .then((arquivo) {
            if (arquivo != null) {
              BlocProvider.getBloc<ImagemBloc>().subirImagem(arquivo);
            }
          });
        });
  }
}
