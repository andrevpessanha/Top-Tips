import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/views/anuncios_view.dart';
import 'package:ad_catalog/views/cadastro_loja_view.dart';
import 'package:ad_catalog/views/processamento_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class OpcoesPrivadasWidget extends StatelessWidget {
  const OpcoesPrivadasWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('COMPILANDO WIDGET DE OPCOES PRIVADAS');
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2),
            child: ListTile(
              title: Text("Anúncios",
                  style: TextStyle(fontSize: 20, color: Colors.black54)),
              trailing: Icon(Icons.format_list_bulleted),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AnunciosView()));
              },
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2),
                child: ListTile(
                  title: Text("Editar Loja",
                      style: TextStyle(fontSize: 20, color: Colors.black54)),
                  trailing: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CadastroLojaView(editar: true)));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0, bottom: 20.0),
                child: ListTile(
                  title: Text("Sair",
                      style: TextStyle(fontSize: 20, color: Colors.black54)),
                  trailing: Icon(Icons.exit_to_app),
                  onTap: () {
                    BlocProvider.getBloc<UsuarioBloc>().deslogar();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProcessamentoView()));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
