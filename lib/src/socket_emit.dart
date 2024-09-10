import 'socket_service.dart';
import 'crypto.dart';

void _baseEmitter({
  required SocketService socket,
  required String event,
  required Map<String, dynamic> data,
}) {
  final Map<String, dynamic> encryptedData =
      CryptoUtils.encryptEventsData(data);
  if (encryptedData['success'] == true) {
    final Map<String, dynamic> jsonData = {
      "data": encryptedData['data'],
    };
    socket.emit(event, jsonData);
  } else {
    throw Exception("Failed to encrypt data: ${encryptedData['errorMessage']}");
  }
}

void emitCreateRoom({
  required SocketService socket,
  required String roomId,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
  };
  _baseEmitter(socket: socket, event: 'create-room', data: data);
}

void emitDeleteRoom({
  required SocketService socket,
  required String roomId,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
  };
  _baseEmitter(socket: socket, event: 'delete-room', data: data);
}

void emitJoinRoom({
  required SocketService socket,
  required String roomId,
  required String username,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
  };
  _baseEmitter(socket: socket, event: 'join-room', data: data);
}

void emitLeaveRoom({
  required SocketService socket,
  required String roomId,
  required String username,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
  };
  _baseEmitter(socket: socket, event: 'leave-room', data: data);
}

void emitSendMessage({
  required SocketService socket,
  required String roomId,
  required String username,
  required dynamic message,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
    "message": message,
  };
  _baseEmitter(socket: socket, event: 'send-message', data: data);
}

void emitEditMessage({
  required SocketService socket,
  required String roomId,
  required String username,
  required String messageId,
  required dynamic newMessage,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
    "messageId": messageId,
    "message": newMessage,
  };
  _baseEmitter(socket: socket, event: 'edit-message', data: data);
}

void emitDeleteMessage({
  required SocketService socket,
  required String roomId,
  required String username,
  required String messageId,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
    "messageId": messageId,
  };
  _baseEmitter(socket: socket, event: 'delete-message', data: data);
}

void emitStartTyping({
  required SocketService socket,
  required String roomId,
  required String username,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
  };
  _baseEmitter(socket: socket, event: 'typing', data: data);
}

void emitStopTyping({
  required SocketService socket,
  required String roomId,
  required String username,
}) {
  final Map<String, dynamic> data = {
    "roomId": roomId,
    "userName": username,
  };
  _baseEmitter(socket: socket, event: 'stop-typing', data: data);
}
