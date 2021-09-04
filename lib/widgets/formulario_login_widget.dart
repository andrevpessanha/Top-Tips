import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/views/processamento_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class FormularioLoginWidget extends StatefulWidget {
  FormularioLoginWidget({Key key}) : super(key: key);

  _FormularioLoginWidgetState createState() => _FormularioLoginWidgetState();
}

class _FormularioLoginWidgetState extends State<FormularioLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _senhaTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 130.0),
          children: <Widget>[
            Image(image: AssetImage("imagens/TopTips.png"),
              height: 40,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(hintText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (email) {
                if (email.isEmpty) return 'Campo obrigatório';
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLength: 18,
              controller: _senhaTextController,
              decoration: InputDecoration(hintText: 'Senha'),
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (senha) {
                if (senha.isEmpty) return 'Campo obrigatório';
                if (senha.length < 6 && senha.length > 18)
                  return 'A senha deve conter entre 6 e 18 caracteres';
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Text('Recuperar senha'),
                onPressed: () {
                  if (_emailTextController.text.isEmpty ||
                      !_emailTextController.text.contains('@') ||
                      !_emailTextController.text.contains('.')) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Insira um e-mail válido para recuperação'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    BlocProvider.getBloc<UsuarioBloc>()
                        .recuperarSenha(_emailTextController.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProcessamentoView()));
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Entrar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  BlocProvider.getBloc<UsuarioBloc>().logar(
                      _emailTextController.text, _senhaTextController.text);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProcessamentoView()));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
