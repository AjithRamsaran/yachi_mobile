import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketService {
  Stream<Map<String, dynamic>> get cartUpdates;

  Future<void> connect();

  void disconnect();
}

class WebSocketServiceImpl implements WebSocketService {
  late WebSocketChannel _channel;
  final StreamController<Map<String, dynamic>> _cartController =
      StreamController.broadcast();

  @override
  Stream<Map<String, dynamic>> get cartUpdates => _cartController.stream;

  @override
  Future<void> connect() async {
    _channel = WebSocketChannel.connect(Uri.parse("ws://0.0.0.0:8000/api/v1/cart/ws/cart"));

    await _channel.ready;

    _channel.stream.listen((message) {
//      _channel.sink.add('received!');

      print("Websocket data $message");

      try {
        final decoded = jsonDecode(message);

        if (decoded is Map<String, dynamic>) {
          _cartController.add(decoded);
        } else {
          print("Unexpected format: $decoded");
        }
      } catch (e) {
        print("Error decoding message: $e");
      }
    });




  }

  @override
  void disconnect() {
    _channel.sink.close();
    _cartController.close();
  }
}
