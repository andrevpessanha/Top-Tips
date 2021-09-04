import 'package:ad_catalog/widgets/cabecalho_widget.dart';
import 'package:ad_catalog/widgets/opcoes_widget.dart';
import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  SidebarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Drawer(
        child: Column(
          children: <Widget>[
            CabecalhoWidget(),
            Expanded(
              child: OpcoesWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
