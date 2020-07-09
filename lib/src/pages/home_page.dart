import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_practica/src/bloc/scans_bloc.dart';
import 'package:qr_reader_practica/src/models/scan_model.dart';
import 'package:qr_reader_practica/src/pages/direcciones_page.dart';
import 'package:qr_reader_practica/src/pages/mapas_page.dart';
import 'package:qr_reader_practica/src/utils/scan_util.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  final ScansBloc scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(),
      body: _cargarPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearFloatingActionButton(context),
    );
  }


  Widget _crearAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text('QR Scanner App'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever), 
          onPressed: (){
            scansBloc.borrarScans();
          }
        ),
      ],
    );
  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }

  Widget _cargarPage( int paginaActual ) {

    switch (paginaActual) {
      case 0  : return MapasPage();
      case 1  : return DireccionesPage();
      default : return MapasPage();
    }
  }

  Widget _crearFloatingActionButton( BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => _scanQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _scanQR(BuildContext context) async {
    //geo:6.344696188197447,-75.53072348078616
    //https://github.com/sriverarestrepo
    ScanResult scanResult;
    String resultStr = '';

    try {
      scanResult = await BarcodeScanner.scan();
      resultStr  = scanResult.rawContent;
    } catch (e) {
      resultStr = e.toString();
    }

    if(resultStr != null){
      final scan = ScanModel(valor: resultStr);
      utils.abrirScan(context,scan);
      scansBloc.agregarScan(scan);
    }

  }

}