import 'package:ad_catalog/views/cadastro_loja_view.dart';
import 'package:ad_catalog/widgets/formulario_login_widget.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child:
                Text('CADASTRAR LOJA' , style: TextStyle(color: Colors.white, fontSize: 13)),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CadastroLojaView()));
            },
          )
        ],
      ),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE LOGIN');
      return Container(
        color: Theme.of(context).backgroundColor,
        child: FormularioLoginWidget(),
      );
    }
    return Container();
  }
}
