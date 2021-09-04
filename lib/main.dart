import 'package:ad_catalog/blocs/anuncios_bloc.dart';
import 'package:ad_catalog/blocs/categorias_bloc.dart';
import 'package:ad_catalog/blocs/imagem_bloc.dart';
import 'package:ad_catalog/blocs/localizations_bloc.dart';
import 'package:ad_catalog/blocs/loja_bloc.dart';
import 'package:ad_catalog/blocs/marcas_bloc.dart';
import 'package:ad_catalog/blocs/processamento_bloc.dart';
import 'package:ad_catalog/blocs/produtos_bloc.dart';
import 'package:ad_catalog/blocs/opcoes_sidebar_bloc.dart';
import 'package:ad_catalog/blocs/usuario_bloc.dart';
import 'package:ad_catalog/delegates/localizations_deletage.dart';
import 'package:ad_catalog/views/produtos_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ad_catalog/blocs/internet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => ProdutosBloc()),
        Bloc((i) => AnunciosBloc()),
        Bloc((i) => LojaBloc()),
        Bloc((i) => OpcoesSidebarBloc()),
        Bloc((i) => MarcasBloc()),
        Bloc((i) => CategoriasBloc()),
        Bloc((i) => LocalizationsBloc()),
        Bloc((i) => UsuarioBloc()),
        Bloc((i) => ProcessamentoBloc()),
        Bloc((i) => ImagemBloc()),
        Bloc((i) => InternetBloc()),
      ],
      child: CarregamentoView(),
    );
  }
}

class CarregamentoView extends StatelessWidget {
  const CarregamentoView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.getBloc<UsuarioBloc>().carregarUsuario();
    return Container(
      color: Color(0xFFeeeeee),
      child: StreamBuilder(
        stream: BlocProvider.getBloc<UsuarioBloc>().acompanharCarregamento,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data == 'carregou') {
            return CustomMaterialView();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("imagens/TopTips.png"),
                height: 60,
              ),
              SizedBox(height: 40),
              RefreshProgressIndicator(
                  semanticsLabel: 'Carregando...',
                  strokeWidth: 6,
                  backgroundColor: Color(0xFF222831)),
            ],
          );
        },
      ),
    );
  }
}

class CustomMaterialView extends StatelessWidget {
  const CustomMaterialView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.getBloc<LocalizationsBloc>().atualizarIdioma,
      initialData: 'en',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(snapshot.data),
            localizationsDelegates: [
              DemoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: BlocProvider.getBloc<LocalizationsBloc>()
                .obterIdiomas
                .map((language) => Locale(language, '')),
            //title: DemoLocalizations.of(context).title,
            onGenerateTitle: (BuildContext context) =>
                DemoLocalizations.of(context).title,
            theme: ThemeData(
                primaryColor: Color(0xFF222831), // 222831 black
                primaryColorBrightness: Brightness.dark,
                primaryColorDark: Color(0xFFBF565B),
                primaryColorLight: Color(0xFFeeeeee),
                backgroundColor: Color(0xFFeeeeee),
                cardColor:
                    Color(0xFFa9c6de), // 89a3b2 azul a9c6de azul2 fff3b1 yellow
                buttonColor: Color(0xFF5588a3)), // 5588a3 azul
            home: ProdutosView(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
