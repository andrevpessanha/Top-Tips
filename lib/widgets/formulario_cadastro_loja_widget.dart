import 'package:ad_catalog/blocs/loja_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/models/loja.dart';
import 'package:ad_catalog/views/processamento_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class FormularioCadastroLojaWidget extends StatefulWidget {
  final editar;
  FormularioCadastroLojaWidget({Key key, this.editar = false})
      : super(key: key);

  _FormularioCadastroLojaWidgetState createState() =>
      _FormularioCadastroLojaWidgetState();
}

class _FormularioCadastroLojaWidgetState
    extends State<FormularioCadastroLojaWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nomeTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _senhaTextController = TextEditingController();
  final _confirmarSenhaTextController = TextEditingController();
  final _telefoneTextController = TextEditingController();
  final _enderecoTextController = TextEditingController();
  final _descricaoTextController = TextEditingController();
  Loja _loja;

  @override
  void initState() {
    if (widget.editar) {
      _loja = BlocProvider.getBloc<UsuarioBloc>().obterLoja;
      _nomeTextController.text = _loja.nome;
      _emailTextController.text = _loja.email;
      _senhaTextController.text = '12312312';
      _confirmarSenhaTextController.text = '12312312';
      _telefoneTextController.text = _loja.telefone;
      _enderecoTextController.text = _loja.endereco;
      _descricaoTextController.text = _loja.descricao;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          children: <Widget>[
            TextFormField(
              maxLength: 36,
              controller: _nomeTextController,
              decoration: InputDecoration(hintText: 'Nome'),
              keyboardType: TextInputType.text,
              validator: (nome) {
                if (nome.isEmpty) return 'Campo obrigatório';
                if (nome.length < 3 && nome.length > 36)
                  return 'Esse campo só pode ter entre 3 e 36 caracteres';
              },
            ),
            TextFormField(
              enabled: !widget.editar,
              controller: _emailTextController,
              decoration: InputDecoration(hintText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (email) {
                if (email.isEmpty) return 'Campo obrigatório';
                if (!email.contains('@') || !email.contains('.')) {
                  return 'E-mail inválido';
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLength: 18,
              enabled: !widget.editar,
              controller: _senhaTextController,
              decoration: InputDecoration(hintText: 'Senha'),
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (senha) {
                if (senha.isEmpty) return 'Campo obrigatório';
                if (senha.length < 6 && senha.length > 18)
                  return 'A senha deve ter entre 6 e 18 caracteres';
                if (_confirmarSenhaTextController.text.compareTo(senha) != 0) {
                  return 'As senhas devem ser iguais';
                }
              },
            ),
            TextFormField(
              maxLength: 18,
              enabled: !widget.editar,
              controller: _confirmarSenhaTextController,
              decoration: InputDecoration(hintText: 'Confirmar senha'),
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (confirmarSenha) {
                if (confirmarSenha.isEmpty) return 'Campo obrigatório';
                if (confirmarSenha.length < 6 && confirmarSenha.length > 18)
                  return 'A senha deve ter entre 6 e 18 caracteres';
                if (_confirmarSenhaTextController.text.compareTo(confirmarSenha) != 0) {
                  return 'As senhas devem ser iguais';
                }
              },
            ),
            TextFormField(
              maxLength: 18,
              controller: _telefoneTextController,
              decoration: InputDecoration(hintText: 'Telefone'),
              keyboardType: TextInputType.phone,
              validator: (telefone) {
                if (telefone.isEmpty) return 'Campo obrigatório';
                if (telefone.length < 8 && telefone.length > 18)
                  return 'Esse campo só pode ter entre 8 e 18 caracteres';
              },
            ),
            TextFormField(
              maxLength: 36,
              controller: _enderecoTextController,
              decoration: InputDecoration(hintText: 'Endereço'),
              keyboardType: TextInputType.text,
              validator: (endereco) {
                if (endereco.length > 36)
                  return 'Esse campo so pode ter no máximo 36 caracteres';
              },
            ),
            TextFormField(
              controller: _descricaoTextController,
              decoration: InputDecoration(hintText: 'Descrição'),
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 30),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Salvar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(widget.editar);
                  final mapDemaisDados = {
                    'nome': _nomeTextController.text,
                    'email': _emailTextController.text,
                    'telefone': _telefoneTextController.text,
                    'endereco': _enderecoTextController.text,
                    'descricao': _descricaoTextController.text,
                  };
                  if (widget.editar) {
                    mapDemaisDados['id'] = _loja.id;
                    BlocProvider.getBloc<LojaBloc>()
                        .atualizarLoja(mapDemaisDados);
                  } else {
                    BlocProvider.getBloc<UsuarioBloc>().cadastrar(
                        _emailTextController.text,
                        _senhaTextController.text,
                        mapDemaisDados);
                  }

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
