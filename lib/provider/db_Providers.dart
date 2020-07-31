import 'dart:io';
import 'package:crudapp/models/articles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'todo.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE articulos ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'fecha TEXT'
          ')');
    });
  }
    //Crear Registro
    nuevoArticulos( Articles nuevoArticulos ) async {

    final db =  await database;

    final res = await db.insert('articulos', nuevoArticulos.toJson());

    return res;
  }

  //Obtener registros
  Future <List<Articles>> getarticulos() async {

      final db = await database;

      final res = await db.query('articulos');

      List<Articles> list = res.isNotEmpty ? res.map((l) => Articles.fromJson(l)).toList() : [];

      return list;
    }

    //Borrar registros
     Future<int> deletearticulo(int id ) async {

      final db =  await database;

      final res = await db.delete('articulos', where: 'id = ?', whereArgs: [id]);

      return res;
    }

       Future<int> deleteAllArt() async {

      final db =  await database;


      final res = await db.rawDelete('Delete FROM articulos');

      return res;
    }
  //Actlizar 
    updatearticulo( Articles articulo) async {
      final db = await database;

      final res = await db.update('articulos', articulo.toJson(),where: 'id = ?', whereArgs: [articulo.id]);

      return res;
    }

}
