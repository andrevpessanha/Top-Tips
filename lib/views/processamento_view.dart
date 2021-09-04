import 'package:ad_catalog/blocs/processamento_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class ProcessamentoView extends StatelessWidget {
  ProcessamentoView({Key key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Aguarde...'),
        centerTitle: true,
      ),
      body: _obterCorpo(context),
    );
  }

  Widget _obterCorpo(context) {
    final estaVisivel = ModalRoute.of(context).isCurrent;
    if (estaVisivel) {
      print('COMPILANDO TELA DE PROCESSAMENTO');
      return Container(
        color: Theme.of(context).backgroundColor,
        child: StreamBuilder(
          stream: BlocProvider.getBloc<ProcessamentoBloc>().obterEstado,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == 'concluido' ||
                  snapshot.data == 'concluidoComErros') {
                Future.delayed(Duration(seconds: 1)).then((resultado) {
                  Navigator.of(context).pop();
                });

                if (snapshot.data == 'concluido') {
                  return Container(
                    color: Colors.greenAccent,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Sucesso!',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
                  );
                } else {
                  return Container(
                    color: Colors.redAccent,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Houve um erro!',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
                  );
                }
              }
            }
            return Center(
                child: RefreshProgressIndicator(
                    semanticsLabel: 'Processando...',
                    strokeWidth: 6,
                    backgroundColor: Theme.of(context).primaryColor));
          },
        ),
      );
    }
    return Container();
  }
}
