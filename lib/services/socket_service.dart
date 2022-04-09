import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  // Variable de estado del servidor
  ServerStatus _serverStatus = ServerStatus.Connecting;

  // Instanciamos el _socket
  late IO.Socket _socket;

  // Getter para saber el estado del servidor
  ServerStatus get serverStatus => this._serverStatus;

  // Getter para obterner la instacia en otras clases donde se necesitee
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    _socket = IO.io(
        "http://192.168.1.5:3000",
        // "http://192.168.1.7:3000",
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      //socket.emit('mensaje', 'conectado desde app Flutter');
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('msn', (data) {
    //   print('Nuevo Mensaje: ${data}');
    // });
  }

//
}
