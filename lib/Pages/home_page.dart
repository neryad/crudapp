import 'package:crudapp/models/articles.dart';
import 'package:crudapp/provider/db_Providers.dart';
import 'package:crudapp/widgets/bodyList.dart';
import 'package:crudapp/widgets/homeImg.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () => _validateEliminarArt(context)),
                  )
                ],
              ),
              HomeImg(),
              BodyList()
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _mostrarAlertaProducto(context);
        },
        child: Icon(Icons.add_shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _mostrarAlertaProducto(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(' Nuevo artículo'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _crearNombreArticulo(),
                    ],
                  ),
                ),
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
                    _subimt();

                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text(
                    'Aceptar',
                  )),
            ],
          );
        });
  }

  Widget _crearNombreArticulo() {
    return TextFormField(
      //  initialValue: productModel.name,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.center,
      onSaved: (value) => articulostModel.name = value,
      decoration: InputDecoration(
        counterText: '',
        hintText: 'Nombre artículo',
      ),
    );
  }

  void _subimt() {
    var it = art.length;
    DateTime now = new DateTime.now();
    var fecha = '${now.day}/${now.month}/${now.year}';
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    var prod = new Articles(name: articulostModel.name, fecha: fecha);
    art.insert(it, prod);
    DBProvider.db.nuevoArticulos(prod);
    formKey.currentState.reset();
  }

  _validateEliminarArt(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Eliminar contenido'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Salir',
                  )),
              FlatButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                    'Aceptar',
                  )),
            ],
          );
        });
  }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllArt();
      art.clear();
    });
    Navigator.of(context).pop();
  }
}
