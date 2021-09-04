import 'package:ad_catalog/widgets/formulario_cadastro_loja_widget.dart';
import 'package:flutter/material.dart';

class CadastroLojaView extends StatelessWidget {
  final editar;
  CadastroLojaView({Key key, this.editar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editar ? 'Editar Loja' : 'Cadastrar Loja'),
        centerTitle: true,
      ),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE CADASTRAR LOJA');
      return Container(
        color: Theme.of(context).backgroundColor,
        child: FormularioCadastroLojaWidget(editar: editar),
      );
    }
    return Container();
  }
}
