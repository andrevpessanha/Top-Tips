import 'package:ad_catalog/delegates/localizations_deletage.dart';
import 'package:ad_catalog/widgets/filtro_marcas_widget.dart';
import 'package:ad_catalog/widgets/produtos_widget.dart';
import 'package:ad_catalog/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';

class ProdutosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DemoLocalizations.of(context).title),
        centerTitle: true,
      ),
      drawer: SidebarWidget(),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE PRODUTOS');
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            FiltroMarcasWidget(),
            Expanded(child: ProdutosWidget()),
          ],
        ),
      );
    }
    return Container();
  }
}
/*
final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
    }
    return Container();
 */
