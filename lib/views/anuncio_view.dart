import 'package:ad_catalog/blocs/anuncios_bloc.dart';
import 'package:ad_catalog/models/anuncio.dart';
import 'package:ad_catalog/models/produto.dart';
import 'package:ad_catalog/views/cadastro_anuncio_view.dart';
import 'package:ad_catalog/views/processamento_view.dart';
import 'package:ad_catalog/widgets/anuncio_widget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class AnuncioView extends StatelessWidget {
  final Anuncio anuncio;
  final Produto produto;
  final bool editavel;

  AnuncioView({this.anuncio, this.produto, this.editavel = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anuncio.nomeLoja),
        centerTitle: true,
        actions: editavel == true
            ? [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.getBloc<AnunciosBloc>()
                          .removerAnuncio(anuncio.id);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProcessamentoView()));
                    }),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroAnuncioView(
                                  anuncio: anuncio, editar: true)));
                    })
              ]
            : [Container()],
      ),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE ANUNCIO');
      return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(10),
        child: AnuncioWidget(
          anuncio: anuncio,
          editavel: editavel,
        ),
      );
    }
    return Container();
  }
}
