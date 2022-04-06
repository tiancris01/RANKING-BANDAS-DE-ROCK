// Dart
import 'dart:io';
// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Third Party/Others
import 'package:lista_nombres/models/banda.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Heroes', votes: 3),
    Band(id: '3', name: 'Caiganes', votes: 4),
    Band(id: '4', name: 'Fito', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title:
            Text('RANKING DE BANDAS', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => _bandTile(bandas[i]),
        itemCount: bandas.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNevasBandas,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print('direction:$direction');
        // TODO: Llamar el borrado en el server
      },
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
        onTap: () {},
      ),
    );
  }

  addNevasBandas() {
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      // Android
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
          );
        },
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
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
          );
        });
  }

  void agregarBandaLista(String name) {
    print(name);
    if (name.length > 1) {
      // Podemos agregar
      this
          .bandas
          .add(Band(id: DateTime.now().toString(), name: name, votes: 0));
    }
    Navigator.pop(context);
  }
}
