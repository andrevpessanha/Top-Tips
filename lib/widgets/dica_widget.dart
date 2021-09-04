import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DicaWidget extends StatelessWidget {
  final DocumentSnapshot snapshot;

  DicaWidget(this.snapshot);

  @override
  Widget build(BuildContext context) {
    print(snapshot.data["imagemUrl"]);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              snapshot.data["imagemUrl"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(snapshot.data["nome"],
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
                Text(
                  snapshot.data["endereco"],
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Ligar"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      textColor: Theme.of(context).primaryColorLight,
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        launch("tel: ${snapshot.data["telefone"]}");
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    RaisedButton(
                      child: Text("Ver no Mapa"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      textColor: Theme.of(context).primaryColorLight,
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        launch(
                            "https://www.google.com/maps/search/?api=1&query=${snapshot.data["endereco"]}");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
