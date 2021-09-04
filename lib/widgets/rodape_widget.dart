import 'package:ad_catalog/blocs/localizations_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class RodapeWidget extends StatelessWidget {
  const RodapeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<LocalizationsBloc>();
    return Container(
      height: 30,
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              bloc.alterarIdiomaPara('pt');
              Navigator.pop(context);
            },
            child: Container(
              height: 100,
              width: 40,
              child: Image.asset(
                'imagens/br.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              bloc.alterarIdiomaPara('en');
              Navigator.pop(context);
            },
            child: Container(
              height: 100,
              width: 40,
              child: Image.asset(
                'imagens/us.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              bloc.alterarIdiomaPara('es');
              Navigator.pop(context);
            },
            child: Container(
              height: 100,
              width: 40,
              child: Image.asset(
                'imagens/es.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
