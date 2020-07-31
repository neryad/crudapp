import 'package:crudapp/models/articles.dart';
import 'package:crudapp/provider/db_Providers.dart';
import 'package:flutter/material.dart';

class BodyList extends StatefulWidget {
  BodyList({Key key}) : super(key: key);

  @override
  _BodyListState createState() => _BodyListState();
}

final formKey = GlobalKey<FormState>();
final editFormKey = GlobalKey<FormState>();
Articles articulostModel = new Articles();
List<Articles> art = [];

class _BodyListState extends State<BodyList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      child: FutureBuilder<List<Articles>>(
        future: DBProvider.db.getarticulos(),
        builder: (context, AsyncSnapshot<List<Articles>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          art = snapshot.data;

          if (art.length == 0) {
            return Container(
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'No se han agregado artículos a la lista',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ]),
            );
          }
          art.sort((a, b) => b.name.compareTo(a.name));

          return ListView.builder(
              itemCount: art.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              "Eliminar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  key: Key(art[i].name + art.length.toString()),
                  onDismissed: (direction) {
                    DBProvider.db.deletearticulo(art[i].id);
                    art.removeAt(i);
                    setState(() {});
                  },
                  child: GestureDetector(
                      onTap: () {
                        _mostrarAlertaEditarArt(context, i);
                      },
                      child: _card(art[i])),
                );
              });
        },
      ),
    );
  }

  Widget _card(Articles articulos) {
    return Container(
      height: 80.00,
      child: Card(
        elevation: 3.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Icon(Icons.dashboard,color: Colors.blue),
            Text(articulos.name),
            Text(articulos.fecha,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            Icon(Icons.arrow_left, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  void _mostrarAlertaEditarArt(BuildContext context, int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Modificar articulo'),
            content: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _editarNombreArticulo(index),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Salir',
                  )),
              FlatButton(
                  onPressed: () {
                    _editDubimt(index);

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                  )),
            ],
          );
        });
  }

  void _editDubimt(int index) {
    editFormKey.currentState.save();
    DBProvider.db.updatearticulo(art[index]);

    setState(() {});
  }

  Widget _editarNombreArticulo(int index) {
    return TextFormField(
      initialValue: art[index].name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => art[index].name = value,
    );
  }
}
