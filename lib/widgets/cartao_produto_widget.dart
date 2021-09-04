import 'package:ad_catalog/models/produto.dart';
import 'package:ad_catalog/views/produto_view.dart';
import 'package:flutter/material.dart';

class CartaoProdutoWidget extends StatelessWidget {
  final Produto produto;
  const CartaoProdutoWidget({Key key, this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdutoView(produto: produto),
            ),
          );
        },
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: produto.imagemUrl != null
                      ? NetworkImage(produto.imagemUrl)
                      : AssetImage("imagens/sem_foto.gif"),
                  radius: 40,
                ),
                Expanded(
                  child: ListTile(
                    title: Text('${produto.categoria} ${produto.marca}'),
                    subtitle: Text('${produto.modelo}'),
                    trailing: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
