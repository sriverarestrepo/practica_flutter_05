import 'dart:async';
import 'package:qr_reader_practica/src/providers/db_provider.dart';
import 'package:qr_reader_practica/src/bloc/validaciones.dart';


class ScansBloc with Validaciones{
  
  static final ScansBloc _singleton = new ScansBloc._internal();
  
  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //Obtener Scans de la BD
    obtenerScans();
  }


  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);

  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);


  dispose(){
    _scansController?.close();
  }


  obtenerScans() async{
    _scansController.sink.add(await DBProvider.db.getScanAll());
  }

  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  actualizarScan(ScanModel scan) async{
    await DBProvider.db.updateScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScans() async{
    await DBProvider.db.deleteScanAll();
    obtenerScans();  
  }


}