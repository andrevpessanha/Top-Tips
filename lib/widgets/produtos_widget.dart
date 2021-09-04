import 'package:ad_catalog/blocs/produtos_bloc.dart';
import 'package:ad_catalog/widgets/cartao_produto_widget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class ProdutosWidget extends StatelessWidget {
  const ProdutosWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProdutosBloc bloc = BlocProvider.getBloc<ProdutosBloc>();
    bloc.atualizarProdutos();
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: StreamBuilder<List>(
        stream: bloc.obterProdutos,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CartaoProdutoWidget(produto: snapshot.data[index]);
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
