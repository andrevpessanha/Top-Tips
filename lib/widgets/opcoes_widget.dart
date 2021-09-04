import 'package:ad_catalog/blocs/opcoes_sidebar_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/widgets/filtro_categorias_widget.dart';
import 'package:ad_catalog/widgets/opcoes_privadas_widget.dart';
import 'package:ad_catalog/widgets/opcoes_publicas_widget.dart';
import 'package:ad_catalog/widgets/rodape_widget.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class OpcoesWidget extends StatelessWidget {
  var _opcoesAtivadas = false;
  OpcoesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('COMPILANDO WIDGET DE OPCOES');
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: BlocProvider.getBloc<OpcoesSidebarBloc>()
                  .detalhesUsuarioAtivo,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _opcoesAtivadas = snapshot.data;
                }
                else return Container();
                if (_opcoesAtivadas) {
                  final bloc = BlocProvider.getBloc<UsuarioBloc>();
                  if (bloc.estaLogado()) {
                    return OpcoesPrivadasWidget();
                  } else {
                    return OpcoesPublicasWidget();
                  }
                }
                return FiltroCategoriasWidget();
              },
            ),
          ),
          RodapeWidget(),
        ],
      ),
    );
  }
}
