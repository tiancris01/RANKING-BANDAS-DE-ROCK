// Dart
import 'dart:io';
// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
// Third Party/Others
import 'package:lista_nombres/models/banda.dart';
import 'package:lista_nombres/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    // Band(id: '1', name: 'Metalica', votes: 5),
    // Band(id: '2', name: 'Heroes', votes: 3),
    // Band(id: '3', name: 'Caiganes', votes: 4),
    // Band(id: '4', name: 'Fito', votes: 2),
  ];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _manejarBandas);
    super.initState();
  }

  _manejarBandas(dynamic data) {
    this.bandas = (data as List).map((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of(context); ..... SocketService
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('RANKING', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          mostrarGrafica(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) => _bandTile(bandas[i]),
              itemCount: bandas.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNevasBandas,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band banda) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => socketService.socket.emit('borrar', {'id': banda.id}),
      background: Container(
        padding: EdgeInsets.only(right: 8.0),
        color: Colors.red,
        child: Align(
          child: Text(
            'Borrar Banda',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0),
          ),
          alignment: Alignment.centerRight,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0, 2)),
        ),
        title: Text(
          banda.name,
          style: TextStyle(fontSize: 20),
        ),
        trailing: Text(
          '${banda.votes}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: () => socketService.socket.emit('votos', {'id': banda.id}),
      ),
    );
  }

  addNevasBandas() {
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      // Android
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Nombre de la Banda'),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                      child: Text('add'),
                      elevation: 5,
                      textColor: Colors.blue,
                      onPressed: () => agregarBandaLista(textController.text))
                ],
              ));
    }
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Nombre de la Banda'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('add'),
                  onPressed: () => agregarBandaLista(textController.text),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Dismiss'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  void agregarBandaLista(String name) {
    if (name.length > 1) {
      // Podemos agregar
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('agregar', {'name': name});
    }
    Navigator.pop(context);
  }

  mostrarGrafica() {
    Map<String, double> dataMap = {
      "name": 5,
      "React": 3,
      "Xamarin": 2,
      "Ionic": 2,
    };

    return PieChart(dataMap: dataMap);
  }
}
