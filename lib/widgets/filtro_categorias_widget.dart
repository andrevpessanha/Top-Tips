import 'package:ad_catalog/blocs/categorias_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class FiltroCategoriasWidget extends StatelessWidget {
  const FiltroCategoriasWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<CategoriasBloc>();
    bloc.atualizarLista();
    return Container(
      child: StreamBuilder<List<Map<String, bool>>>(
        stream: bloc.obterCategorias,
        initialData: [],
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, bool>>> snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.length > 0){
              return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final filtro = snapshot.data[index].keys.first.toString();
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: snapshot.data[index][filtro]
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight),
                    child: ListTile(
                      title: Text(filtro,
                          style:
                              TextStyle(fontSize: 20, color: Colors.black54)),
                      selected: snapshot.data[index][filtro],
                      trailing: Icon(Icons.filter_list),
                      onTap: () {
                        bloc.alternarFiltros(filtro);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
            }
            else{
              return Container();
            } 
          }
          return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

/*
color: snapshot.data[index][filtro] ? Colors.grey : Colors.pink,
                  elevation: 10,
                  onPressed: () {
                    print('Filtro: ' + filtro);
                    print('Ativo? ' + snapshot.data[index][filtro].toString());
                    bloc.alternarFiltros(filtro);
                  },
 */
