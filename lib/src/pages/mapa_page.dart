import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader_practica/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){}
          )
        ],
      ),
      body: _crearFlutterMap(scan),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {


    return FlutterMap(
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
        maxZoom: 20,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),

      ],
    );

  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
      'accessToken':'pk.eyJ1Ijoic3JycGx1cyIsImEiOiJja2NlMjJnODYwMjNkMnprMmwwdmR3MXlxIn0.3CztlFdk3LsM-nN3sHe-vA',
      'id': 'mapbox.satellite'
      // streets , dark, light, outdoors, satellite
      },
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
              child: Icon(
                Icons.location_on, 
                size: 70.0,
                color: Theme.of(context).primaryColor,
              )
            )
        ),

      ]

    );
  }


}