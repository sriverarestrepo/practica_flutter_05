import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_reader_practica/src/models/scan_model.dart';
export 'package:qr_reader_practica/src/models/scan_model.dart';


class DBProvider {
  
  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) { },
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE SCANS ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }    
    );

  }


  // Crear Resgistros

  Future<int> nuevoScanRaw( ScanModel nuevoScan ) async{

    final db = await database;

    final result = await db.rawInsert(
      "INSERT INTO SCANS (id, tipo, valor) "
      "VALUES ( ${nuevoScan.id} ,'${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );    

    return result;
  }
  
  Future<int> nuevoScan(ScanModel nuevoScan) async{
    final db      = await database;
    final result  = await db.insert('SCANS', nuevoScan.toJson());
    
    return result;
  }

  // Select - Obtener informacion

  Future<ScanModel> getScanId( int id) async{
    final db      = await database;
    final result  = await db.query("SCANS", where: 'id =?', whereArgs: [id] );

    return result.isNotEmpty ? ScanModel.fromJson(result.first): null;
  }

  Future<List<ScanModel>> getScanAll() async{
    final db      = await database;
    final result  = await db.query("SCANS");

    List<ScanModel> list = result.isNotEmpty ? 
                           result.map((scan) => ScanModel.fromJson(scan)).toList()
                           : [];

   return list;

  }

   Future<List<ScanModel>> getScanAllFromTipo( String tipo ) async{
    final db      = await database;
    final result  = await db.query("SCANS", where: 'tipo =?', whereArgs: [tipo] );

    List<ScanModel> list = result.isNotEmpty ? 
                           result.map((scan) => ScanModel.fromJson(scan)).toList()
                           : [];

   return list;

  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db      = await database;
    final result  = await db.update(
      "SCANS", 
      nuevoScan.toJson(),
      where: 'id = ?',
      whereArgs: [nuevoScan.id]
    );

    return result;
  }

  //Eliminar registros

  Future<int> deleteScan( int id ) async{
    final db      = await database;
    final result  = await db.delete(
      "SCANS",
      where: 'id =?',
      whereArgs: [id]
    );

    return result;
  }

  Future<int> deleteScanAll( ) async{
    final db      = await database;
    final result  = await db.delete("SCANS");
    return result;
  }

}