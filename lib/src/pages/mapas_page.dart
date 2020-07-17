import 'package:flutter/material.dart';
import 'package:qr_reader_practica/src/bloc/scans_bloc.dart';
import 'package:qr_reader_practica/src/models/scan_model.dart';
import 'package:qr_reader_practica/src/utils/scan_util.dart' as utils;

class MapasPage extends StatelessWidget {

  final ScansBloc scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if( !snapshot.hasData ){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scanList = snapshot.data;

        if(scanList.length == 0){
          return Center(
            child: Text('No hay información.'),
          );
        }
        
        return ListView.builder(
          itemCount: scanList.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.redAccent,),
            secondaryBackground: Container(color: Colors.red,),
            onDismissed: (direccion) {
               print('Direccion: $direccion');
               scansBloc.borrarScan(scanList[i].id);
            },
            child: ListTile(
              leading: Icon(Icons.map,
                color: Theme.of(context).primaryColor,
                ),
              title: Text(scanList[i].valor),
              subtitle: Text('ID ${scanList[i].id}'),
              trailing: Icon(
                Icons.keyboard_arrow_right, 
                color: Colors.grey,
                ),
              onTap: () => utils.abrirScan(context, scanList[i]),
            ),
          )
        );

      },
    );
  }
}