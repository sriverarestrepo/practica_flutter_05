import 'dart:async';
import 'package:qr_reader_practica/src/models/scan_model.dart';

class Validaciones {
  
  final validarGeo = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink) {
      final geoScans = scans.where((scan) => scan.tipo == 'geo').toList();
      sink.add(geoScans);
    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink) {
      final httpScans = scans.where((scan) => scan.tipo == 'http').toList();
      sink.add(httpScans);
    }
  );

}