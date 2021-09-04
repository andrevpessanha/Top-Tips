import 'package:ad_catalog/widgets/dica_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DicasView extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Dicas'),
        centerTitle: true,
      ),
      body: _obterCorpo(context),
    );
  }
}

Widget _obterCorpo(context){  
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("lojas").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          children: snapshot.data.documents.map( (doc) => DicaWidget(doc) ).toList()
        );
      },
    );
}
