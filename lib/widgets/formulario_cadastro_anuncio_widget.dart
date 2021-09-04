import 'package:ad_catalog/blocs/anuncios_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/views/processamento_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class FormularioCadastroAnuncioWidget extends StatefulWidget {
  final anuncio;
  final editar;
  FormularioCadastroAnuncioWidget({Key key, this.anuncio, this.editar = false})
      : super(key: key);

  _FormularioCadastroAnuncioWidgetState createState() =>
      _FormularioCadastroAnuncioWidgetState();
}

class _FormularioCadastroAnuncioWidgetState
    extends State<FormularioCadastroAnuncioWidget> {
  final _formKey = GlobalKey<FormState>();
  final _categoriaTextController = TextEditingController();
  final _marcaTextController = TextEditingController();
  final _modeloTextController = TextEditingController();
  final _valorTextController = TextEditingController();
  final _descricaoTextController = TextEditingController();

  @override
  void initState() {
    if (widget.editar == true && widget.anuncio != null) {
      _categoriaTextController.text = widget.anuncio.categoria;
      _marcaTextController.text = widget.anuncio.marca;
      _modeloTextController.text = widget.anuncio.modelo;
      _valorTextController.text = widget.anuncio.valor.toString();
      _descricaoTextController.text = widget.anuncio.descricao;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          children: <Widget>[
            TextFormField(
              enabled: !widget.editar,
              maxLength: 18,
              controller: _categoriaTextController,
              decoration: InputDecoration(hintText: 'Categoria'),
              keyboardType: TextInputType.text,
              validator: (categoria) {
                if (categoria.isEmpty) return 'Campo obrigatório';
                if (categoria.length < 3 && categoria.length > 18)
                  return 'Esse campo só pode ter entre 3 e 18 caracteres';
              },
            ),
            TextFormField(
              enabled: !widget.editar,
              maxLength: 18,
              controller: _marcaTextController,
              decoration: InputDecoration(hintText: 'Marca'),
              keyboardType: TextInputType.text,
              validator: (marca) {
                if (marca.isEmpty) return 'Campo obrigatório';
                if (marca.length < 3 && marca.length > 18)
                  return 'Esse campo só pode ter entre 3 e 18 caracteres';
              },
            ),
            TextFormField(
              enabled: !widget.editar,
              maxLength: 32,
              controller: _modeloTextController,
              decoration: InputDecoration(hintText: 'Modelo'),
              keyboardType: TextInputType.text,
              validator: (modelo) {
                if (modelo.isEmpty) return 'Campo obrigatório';
                if (modelo.length < 3 && modelo.length > 32)
                  return 'Esse campo só pode ter entre 3 e 32 caracteres';
              },
            ),
            TextFormField(
              controller: _valorTextController,
              decoration: InputDecoration(hintText: 'Valor'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (valor) {
                if (valor.isEmpty) return 'Campo obrigatório';
                if (valor.contains(',')) return 'Use ponto ao invés de vírgula';
                if (double.tryParse(valor) == null)
                  return 'Esse campo deve conter no máximo 1 ponto.';
              },
            ),
            SizedBox(height: 20),
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
                  if (widget.editar == false) {
                    final loja = BlocProvider.getBloc<UsuarioBloc>().obterLoja;
                    BlocProvider.getBloc<AnunciosBloc>().cadastrarAnuncio({
                      'idLoja': loja.id,
                      'nomeLoja': loja.nome,
                      'categoria': _categoriaTextController.text,
                      'marca': _marcaTextController.text,
                      'modelo': _modeloTextController.text,
                      'valor': double.parse(
                          _valorTextController.text.replaceFirst(',', '.')),
                      'descricao': _descricaoTextController.text,
                    });
                  } else {
                    BlocProvider.getBloc<AnunciosBloc>().atualizarAnuncio({
                      'id': widget.anuncio.id,
                      'valor': double.parse(
                          _valorTextController.text.replaceFirst(',', '.')),
                      'descricao': _descricaoTextController.text,
                    });
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
