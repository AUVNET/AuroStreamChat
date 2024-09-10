import 'package:auro_stream_chat/auro_stream_chat.dart';
import 'package:flutter/services.dart';

class AuroStreamChatServices {
  String? username;
  String? roomId;
  List<Message> messages = [];
  List<String> typingList = [];
  VoidCallback? updateUI;

  AuroStreamChatServices();

  void initUsername({
    required String usernameId,
  }) {
    username = usernameId;
  }

  void initRoomService({
    required List<Message> messagesList,
    required String targetRoomId,
    required bool isCreateBoolean,
  }) {
    messages = messagesList;
    roomId = targetRoomId;
    if (isCreateBoolean) {
      createRoom();
    } else {
      joinRoom();
    }
  }

  void initUpdateUI({
    required VoidCallback update,
  }) {
    updateUI = update;
  }

  /// Functions Implementation

  void connectServer() {
    AuroStreamChat.instance.connectServer(
      whenConnect: whenConnect,
      whenConnectError: whenConnectError,
      whenReconnect: whenReconnect,
      whenReconnectError: whenReconnectError,
      whenDisconnect: whenDisconnect,
      whenGetError: whenGetError,
    );
  }

  bool isConnected() {
    return AuroStreamChat.instance.isConnected();
  }

  void disconnectServer() {
    return AuroStreamChat.instance.disconnectServer();
  }

  void startListeners() {
    if (isConnected()) {
      AuroStreamChat.instance
          .onJoinRoomListener(whenJoinedRoom: whenJoinedRoom);
      AuroStreamChat.instance.onLeaveRoomListener(whenLeftRoom: whenLeftRoom);
      AuroStreamChat.instance
          .onReceiveMessageListener(whenReceiveMessage: whenReceiveMessage);
      AuroStreamChat.instance
          .onEditMessageListener(whenEditMessage: whenEditMessage);
      AuroStreamChat.instance
          .onDeleteMessageListener(whenDeleteMessage: whenDeleteMessage);
      AuroStreamChat.instance.onTypingListener(whenTyping: whenTyping);
      AuroStreamChat.instance
          .onStoppedTypingListener(whenStoppedTyping: whenStoppedTyping);
    }
  }

  void removeListeners() {
    /// To remove listener should set removeListener true (default false)
    if (isConnected()) {
      AuroStreamChat.instance.onJoinRoomListener(
        whenJoinedRoom: whenJoinedRoom,
        removeListener: true,
      );
      AuroStreamChat.instance.onLeaveRoomListener(
        whenLeftRoom: whenLeftRoom,
        removeListener: true,
      );
      AuroStreamChat.instance.onReceiveMessageListener(
        whenReceiveMessage: whenReceiveMessage,
        removeListener: true,
      );
      AuroStreamChat.instance.onEditMessageListener(
        whenEditMessage: whenEditMessage,
        removeListener: true,
      );
      AuroStreamChat.instance.onDeleteMessageListener(
        whenDeleteMessage: whenDeleteMessage,
        removeListener: true,
      );
      AuroStreamChat.instance.onTypingListener(
        whenTyping: whenTyping,
        removeListener: true,
      );
      AuroStreamChat.instance.onStoppedTypingListener(
        whenStoppedTyping: whenStoppedTyping,
        removeListener: true,
      );
    }
  }

  void createRoom() async {
    AuroStreamChat.instance.createRoom(
      roomId: roomId!,
    );
  }

  void deleteRoom() async {
    AuroStreamChat.instance.deleteRoom(
      roomId: roomId!,
    );
  }

  void joinRoom() {
    AuroStreamChat.instance.joinRoom(
      roomId: roomId!,
      username: username!,
    );
  }

  void leaveRoom() {
    AuroStreamChat.instance.leaveRoom(
      roomId: roomId!,
      username: username!,
    );
  }

  void sendMessage(Message message) {
    messages.add(message);

    /// Before using the sendMessage function, you should save the message to your database and confirm that it has been saved successfully.
    AuroStreamChat.instance.sendMessage(
      roomId: roomId!,
      username: username!,
      message: message,
    );
  }

  void editMessage(Message newMessage) {
    var updatedMessages = messages.map((message) {
      if (message.id == newMessage.id) {
        return newMessage;
      }
      return message;
    }).toList();
    messages = updatedMessages;

    /// Before using the editMessage function, you should edit the message in your database and confirm that it has been edited successfully.
    AuroStreamChat.instance.editMessage(
      roomId: roomId!,
      username: username!,
      messageId: newMessage.id,
      newMessage: newMessage,
    );
  }

  void deleteMessage(String messageId) {
    messages.removeWhere((msg) => msg.id == messageId);

    /// Before using the deleteMessage function, you should delete the message from your database and confirm that it has been deleted successfully.
    AuroStreamChat.instance.deleteMessage(
      roomId: roomId!,
      username: username!,
      messageId: messageId,
    );
  }

  void startTyping() {
    AuroStreamChat.instance.startTyping(
      roomId: roomId!,
      username: username!,
    );
  }

  void stopTyping() {
    AuroStreamChat.instance.stopTyping(
      roomId: roomId!,
      username: username!,
    );
  }

  /// Listeners Implementation

  whenConnect() {
    print('Connected');
    startListeners();
  }

  whenReconnect(data) {
    print('Reconnected: $data');
  }

  whenReconnectError(data) {
    print('Reconnected Error: $data');
  }

  whenConnectError(data) {
    print('Connection error: $data');
  }

  whenDisconnect() {
    print('Disconnected');
  }

  whenGetError(ErrorModel data) {
    print(data.eventName); // Printing the event name for all cases
    switch (data.eventName) {
      case ErrorCases.createRoom:
        print('Handling createRoom');
        handleCreateRoomErrors(data.message); // Specific handler for createRoom
        break;
      case ErrorCases.deleteRoom:
        print('Handling deleteRoom');
        handleDeleteRoomErrors(data.message); // Generic handler used
        break;
      case ErrorCases.joinRoom:
        print('Handling joinRoom');
        handleJoinRoomErrors(data.message); // Generic handler used
        break;
      case ErrorCases.leaveRoom:
        print('Handling leaveRoom');
        handleLeaveRoomErrors(data.message); // Generic handler used
        break;
      case ErrorCases.sendMessage:
        print('Handling sendMessage');
        handleSendMessageErrors(data.message); // Generic handler used
        break;
      case ErrorCases.editMessage:
        print('Handling editMessage');
        handleEditMessageErrors(data.message); // Generic handler used
        break;
      case ErrorCases.deleteMessage:
        print('Handling deleteMessage');
        handleDeleteMessageErrors(data.message); // Generic handler used
        break;
      case ErrorCases.typing:
        print('Handling typing');
        handleTypingErrors(data.message); // Generic handler used
        break;
      case ErrorCases.stopTyping:
        print('Handling stopTyping');
        handleStopTypingErrors(data.message); // Generic handler used
        break;
      default:
        print('Unhandled case: ${data.eventName}');
        break;
    }
  }

  void handleCreateRoomErrors(ErrorMSG message) {
    print('Handling createRoom errors');
    switch (message) {
      case ErrorMSG.invalidCredentials:
        print('Handling invalidCredentials error');
        break;
      case ErrorMSG.encryptionFailed:
        print('Handling encryptionFailed error');
        break;
      default:
        print('Unhandled error message: $message');
        break;
    }
  }

  void handleDeleteRoomErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleJoinRoomErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleLeaveRoomErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleSendMessageErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleEditMessageErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleDeleteMessageErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleTypingErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void handleStopTypingErrors(ErrorMSG message) {
    genericErrorHandler(message);
  }

  void genericErrorHandler(ErrorMSG message) {
    print('Handling errors');
    switch (message) {
      case ErrorMSG.invalidCredentials:
        print('Handling invalidCredentials error');
        break;
      case ErrorMSG.authorizationFailed:
        print('Handling authorizationFailed error');
        break;
      case ErrorMSG.encryptionFailed:
        print('Handling encryptionFailed error');
        break;
      case ErrorMSG.roomNotFound:
        print('Handling roomNotFound error');
        break;
      default:
        print('Unhandled error message: $message');
        break;
    }
  }

  whenCreateRoomForME(RoomManagementModel roomManagement) {
    print(roomManagement.toString());
  }

  whenDeleteRoom(RoomManagementModel roomManagement) {
    print(roomManagement.toString());
  }

  whenJoinedRoom(RoomActionModel roomAction) {
    print(roomAction.toString());
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenLeftRoom(RoomActionModel roomAction) {
    print(roomAction.toString());
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenReceiveMessage(ReceiveMessageModel receiveMessage) {
    print(receiveMessage.toString());
    final msg = receiveMessage.messageData;
    messages.add(Message.fromJson(msg));
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenEditMessage(EditedMessageModel editedMessage) {
    print(editedMessage.toString());

    final msg = editedMessage.messageData;
    final messageId = editedMessage.messageID;
    final newMessage = Message.fromJson(msg);
    final updatedMessages = messages.map((message) {
      if (message.id == messageId) {
        return newMessage;
      }
      return message;
    }).toList();
    messages = updatedMessages;
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenDeleteMessage(DeletedMessageModel deletedMessage) {
    print(deletedMessage.toString());

    messages.removeWhere((msg) => msg.id == deletedMessage.messageID);
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenTyping(RoomFeedbackModel roomFeedback) {
    print(roomFeedback.toString());
    final username = roomFeedback.username;
    if (!typingList.contains(username)) {
      typingList.add(username);
    }
    if (updateUI != null) {
      updateUI!();
    }
  }

  whenStoppedTyping(RoomFeedbackModel roomFeedback) {
    print(roomFeedback.toString());
    final username = roomFeedback.username;
    if (typingList.contains(username)) {
      typingList.remove(username);
    }
    if (updateUI != null) {
      updateUI!();
    }
  }
}

class Message {
  final String id;
  final String messageText;
  final String sender;
  final bool isEdited;
  final DateTime date;

  Message({
    required this.id,
    required this.messageText,
    required this.sender,
    this.isEdited = false,
    required this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      messageText: json['messageText'],
      sender: json['sender'],
      isEdited: json['isEdited'] ?? false,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageText': messageText,
      'sender': sender,
      'isEdited': isEdited,
      'date': date.toIso8601String(),
    };
  }
}
