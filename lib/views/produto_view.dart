import 'package:ad_catalog/models/produto.dart';
import 'package:ad_catalog/widgets/anuncios_widget.dart';
import 'package:ad_catalog/widgets/descricao_produto_widget.dart';
import 'package:flutter/material.dart';

class ProdutoView extends StatelessWidget {
  final Produto produto;

  ProdutoView({this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto'),
        centerTitle: true,
      ),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE PRODUTO');
      return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            DescricaoProdutoWidget(produto: produto),
            Expanded(
              child: AnunciosWidget(produto: produto),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
