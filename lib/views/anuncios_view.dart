import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/views/cadastro_anuncio_view.dart';
import 'package:ad_catalog/widgets/anuncios_widget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class AnunciosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Anúncios'),
        centerTitle: true,
      ),
      body: _obterCorpo(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.playlist_add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CadastroAnuncioView()));
        },
      ),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE ANUNCIOS');
      final loja = BlocProvider.getBloc<UsuarioBloc>().obterLoja;
      return Container(
        color: Theme.of(context).backgroundColor,
        child: AnunciosWidget(loja: loja, editavel: true),
      );
    }
    return Container();
  }
}
