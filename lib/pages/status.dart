import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:lista_nombres/services/socket_service.dart';

class SatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estado del servidor: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit('emitir mensaje', {
            'nombre': 'Daniel',
            'mensaje': 'Emitido desde flutter',
          });
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
