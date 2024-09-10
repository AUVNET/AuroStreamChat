import 'crypto.dart';
import 'models/models.dart';
import 'socket_service.dart';

void _baseListener({
  required SocketService socket,
  required String event,
  required Function(dynamic data) handler,
  required bool isRemove,
}) {
  listener(encryptedData) {
    final Map<String, dynamic> decryptedData =
        CryptoUtils.decryptEventsData(encryptedData['data']);
    if (decryptedData['success'] == true) {
      final data = decryptedData['data'];
      handler(data);
    } else {
      throw Exception(
          "Failed to decrypt data: ${decryptedData['errorMessage']}");
    }
  }

  if (isRemove) {
    socket.off(event, listener);
  } else {
    socket.on(event, listener);
  }
}

void onCreateRoom({
  required SocketService socket,
  required Function(RoomManagementModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final roomManagement = RoomManagementModel(
      roomID: data['roomId'],
    );
    handler(roomManagement);
  }

  _baseListener(
    socket: socket,
    event: 'room-created',
    handler: listener,
    isRemove: isRemove,
  );
}

void onDeleteRoom({
  required SocketService socket,
  required Function(RoomManagementModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final roomManagement = RoomManagementModel(
      roomID: data['roomId'],
    );
    handler(roomManagement);
  }

  _baseListener(
    socket: socket,
    event: 'room-deleted',
    handler: listener,
    isRemove: isRemove,
  );
}

void onJoinRoom({
  required SocketService socket,
  required Function(RoomActionModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final roomAction = RoomActionModel(
      roomID: data['roomId'],
      userID: data['socketId'],
      username: data['userName'],
    );
    handler(roomAction);
  }

  _baseListener(
    socket: socket,
    event: 'room-joined',
    handler: listener,
    isRemove: isRemove,
  );
}

void onLeaveRoom({
  required SocketService socket,
  required Function(RoomActionModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final roomAction = RoomActionModel(
      roomID: data['roomId'],
      userID: data['socketId'],
      username: data['userName'],
    );
    handler(roomAction);
  }

  _baseListener(
    socket: socket,
    event: 'room-left',
    handler: listener,
    isRemove: isRemove,
  );
}

void onReceiveMessage({
  required SocketService socket,
  required Function(ReceiveMessageModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final message = ReceiveMessageModel(
      userID: data['socketId'],
      username: data['userName'],
      messageData: data['message'],
    );
    handler(message);
  }

  _baseListener(
    socket: socket,
    event: 'message-received',
    handler: listener,
    isRemove: isRemove,
  );
}

void onEditMessage({
  required SocketService socket,
  required Function(EditedMessageModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final message = EditedMessageModel(
      userID: data['socketId'],
      username: data['userName'],
      messageID: data['messageId'],
      messageData: data['message'],
    );
    handler(message);
  }

  _baseListener(
    socket: socket,
    event: 'message-edited',
    handler: listener,
    isRemove: isRemove,
  );
}

void onDeleteMessage({
  required SocketService socket,
  required Function(DeletedMessageModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final message = DeletedMessageModel(
      userID: data['socketId'],
      username: data['userName'],
      messageID: data['messageId'],
    );
    handler(message);
  }

  _baseListener(
    socket: socket,
    event: 'message-deleted',
    handler: listener,
    isRemove: isRemove,
  );
}

void onStartTyping({
  required SocketService socket,
  required Function(RoomFeedbackModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final message = RoomFeedbackModel(
      userID: data['socketId'],
      username: data['userName'],
    );
    handler(message);
  }

  _baseListener(
    socket: socket,
    event: 'typing',
    handler: listener,
    isRemove: isRemove,
  );
}

void onStopTyping({
  required SocketService socket,
  required Function(RoomFeedbackModel data) handler,
  required bool isRemove,
}) {
  listener(data) {
    final message = RoomFeedbackModel(
      userID: data['socketId'],
      username: data['userName'],
    );
    handler(message);
  }

  _baseListener(
    socket: socket,
    event: 'stop-typing',
    handler: listener,
    isRemove: isRemove,
  );
}
