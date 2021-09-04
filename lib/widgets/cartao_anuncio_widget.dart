import 'package:ad_catalog/models/anuncio.dart';
import 'package:ad_catalog/views/anuncio_view.dart';
import 'package:flutter/material.dart';

class CartaoAnuncioWidget extends StatelessWidget {
  final Anuncio anuncio;
  final bool editavel;
  const CartaoAnuncioWidget({Key key, this.anuncio, this.editavel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AnuncioView(anuncio: anuncio, editavel: editavel),
            ),
          );
        },
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: anuncio.imagemUrl != null
                      ? NetworkImage(anuncio.imagemUrl)
                      : AssetImage("imagens/sem_foto.gif"),
                  radius: 40,
                ),
                Expanded(
                  child: ListTile(
                    title: editavel == true
                        ? Text('${anuncio.categoria} ${anuncio.marca}')
                        : Text('${anuncio.nomeLoja}'),
                    subtitle: editavel == true
                        ? Text('${anuncio.modelo}')
                        : Text(
                            '${anuncio.descricao}',
                            maxLines: 3,
                          ),
                    trailing: Text('R\$ ${anuncio.valor.toString()}',
                        style: TextStyle(fontSize: 20)),
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
