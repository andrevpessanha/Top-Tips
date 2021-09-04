import 'package:ad_catalog/models/produto.dart';
import 'package:flutter/material.dart';

class DescricaoProdutoWidget extends StatelessWidget {
  final Produto produto;
  final bool resumida;
  const DescricaoProdutoWidget({Key key, this.produto, this.resumida = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          produto.imagemUrl != null
              ? Image.network(produto.imagemUrl,
                  width: MediaQuery.of(context).size.width * 4.64 / 10,
                  fit: BoxFit.cover)
              : Image.asset("imagens/sem_foto.gif",
                  width: MediaQuery.of(context).size.width * 4.64 / 10,
                  fit: BoxFit.cover),
          Expanded(
            child: ListTile(
              title: Text('${produto.categoria} ${produto.marca}'),
              subtitle: Text('${produto.modelo}'),
            ),
          ),
        ],
      ),
    );
  }
}
