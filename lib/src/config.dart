import 'models/models.dart';
import 'socket_emit.dart';
import 'socket_on.dart';
import 'socket_service.dart';

class AuroStreamChat {
  static String? _instanceId;
  static String? _apiKey;
  static String? _port;
  static SocketService? _socketService;
  static AuroStreamChat? _instance;

  AuroStreamChat._internal();

  static AuroStreamChat get instance {
    _instance ??= AuroStreamChat._internal();
    return _instance!;
  }

  /// Initialize AuroStream Chat SDK with your Project details [projectId], [apiKey], and [port]
  static void initialize({
    required String projectId,
    required String apiKey,
    required String port,
  }) {
    if (projectId.isEmpty) {
      throw ArgumentError("ProjectId cannot be empty.");
    }
    if (apiKey.isEmpty) {
      throw ArgumentError("ApiKey cannot be empty.");
    }
    if (port.isEmpty) {
      throw ArgumentError("Port cannot be empty.");
    }
    _instanceId = projectId;
    _apiKey = apiKey;
    _port = port;
  }

  void _mainValidator() {
    if (_instanceId == null || _instanceId!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a instanceId.");
    }
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a apiKey.");
    }
    if (_port == null || _port!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a port.");
    }
    if (_socketService == null) {
      throw ArgumentError("AuroStream is not connected to socket server.");
    }
  }

  void _validator({
    required String roomId,
    required String username,
  }) {
    _mainValidator();
    if (roomId.isEmpty) {
      throw ArgumentError("Room ID cannot be empty.");
    }
    if (username.isEmpty) {
      throw ArgumentError("Username cannot be empty.");
    }
  }

  /// Initiates a connection to the server and handles various connection events.
  ///
  /// This function is designed to establish a connection to a server and provide
  /// callbacks for different events that can occur during the lifecycle of this
  /// connection. These events include successful connection, errors during
  /// connection, reconnection attempts, disconnection, and generic errors.
  ///
  /// Parameters:
  /// - `whenConnect`: A callback function that is invoked when a connection to the
  ///   server is successfully established. This function takes no parameters.
  ///
  /// - `whenConnectError`: A callback function that is called when there is an error
  ///   while trying to connect to the server. It receives a dynamic parameter `data`
  ///   that contains information about the error.
  ///
  /// - `whenReconnect`: A callback function that is invoked when a reconnection attempt
  ///   is made after losing the connection. It receives a dynamic parameter `data`
  ///   that can contain information related to the reconnection attempt.
  ///
  /// - `whenReconnectError`: Similar to `whenConnectError`, but specifically for
  ///   errors that occur during reconnection attempts. It also receives a dynamic
  ///   parameter `data` with error details.
  ///
  /// - `whenDisconnect`: A callback function that is called when the connection to the
  ///   server is intentionally closed. This function takes no parameters.
  ///
  /// - `whenGetError`: A callback function for handling generic errors that can occur
  ///   with server functions. It receives a dynamic parameter `data`
  ///   with error details.
  void connectServer({
    Function()? whenConnect,
    Function(dynamic data)? whenConnectError,
    Function(dynamic data)? whenReconnect,
    Function(dynamic data)? whenReconnectError,
    Function()? whenDisconnect,
    Function(ErrorModel data)? whenGetError,
  }) {
    if (_instanceId == null || _instanceId!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a instanceId.");
    }
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a apiKey.");
    }
    if (_port == null || _port!.isEmpty) {
      throw ArgumentError("AuroStream is not initialized with a port.");
    }
    _socketService = SocketService(_port!);
    _socketService?.connect(
      instanceId: _instanceId!,
      apiKey: _apiKey!,
      whenConnect: whenConnect,
      whenConnectError: whenConnectError,
      whenReconnect: whenReconnect,
      whenReconnectError: whenReconnectError,
      whenDisconnect: whenDisconnect,
      whenGetError: whenGetError,
    );
  }

  /// Check if server connected
  bool isConnected() {
    _mainValidator();
    return _socketService!.isConnected;
  }

  /// Disconnect server connection
  void disconnectServer() {
    _mainValidator();
    _socketService!.disconnect();
  }

  void onCreateRoomListenerForME({
    required Function(RoomManagementModel roomManagement) whenMECreateRoom,
    bool removeListener = false,
  }) {
    _mainValidator();
    onCreateRoom(
      socket: _socketService!,
      handler: whenMECreateRoom,
      isRemove: removeListener,
    );
  }

  void onDeleteRoomListener({
    required Function(RoomManagementModel roomManagement) whenDeleteRoom,
    bool removeListener = false,
  }) {
    _mainValidator();
    onDeleteRoom(
      socket: _socketService!,
      handler: whenDeleteRoom,
      isRemove: removeListener,
    );
  }

  /// Sets up a listener for tracking when any user joins a chat room.
  ///
  /// Within the real-time chat service package, this function is essential for
  /// enabling dynamic and interactive chat environments. It listens for events
  /// signaling that a user has joined a chat room, facilitating real-time updates
  /// to room participants and supporting features like user count updates, welcome
  /// messages, or activity logs.
  ///
  /// This functionality enhances the chat app's user experience by making chat rooms
  /// feel more alive and responsive. It allows for immediate feedback when new users
  /// join a room, which is crucial for collaborative and social features of the app.
  ///
  /// Parameter:
  /// - `whenJoinedRoom`: A required callback function that is executed whenever a new
  ///   user joins a room. It takes dynamic data about the event, enabling the app to
  ///   respond appropriately, such as updating the UI or notifying existing users.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onJoinRoomListener({
    required Function(RoomActionModel roomManagement) whenJoinedRoom,
    bool removeListener = false,
  }) {
    onJoinRoom(
      socket: _socketService!,
      handler: whenJoinedRoom,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for tracking when a user leaves a chat room.
  ///
  /// This function is an integral part of the chat application's real-time service
  /// package, designed to monitor and react to events when users exit a chat room.
  /// It's pivotal for supporting features that require real-time updates to the
  /// participant list, such as adjusting the user count, removing users from the
  /// chat UI, or triggering notifications about the change in room occupancy.
  ///
  /// The ability to detect and respond to a user leaving a room enhances the
  /// application's interactivity and ensures that the chat environment remains
  /// dynamic and current. It aids in creating a more engaging and informed user
  /// experience by keeping participants aware of the presence and availability
  /// of their peers.
  ///
  /// Parameter:
  /// - `whenLeftRoom`: A required callback function that is invoked when a user
  ///   leaves a room. It receives dynamic data about the event, enabling the
  ///   application to perform necessary updates or actions in response, such as
  ///   displaying a message that a user has exited or updating the room's user list.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onLeaveRoomListener({
    required Function(RoomActionModel roomManagement) whenLeftRoom,
    bool removeListener = false,
  }) {
    onLeaveRoom(
      socket: _socketService!,
      handler: whenLeftRoom,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for receiving new messages in a chat room.
  ///
  /// In the realm of real-time chat applications, this function is crucial for
  /// maintaining an active and engaging conversation flow. It listens for new
  /// messages sent by any user in the chat room and triggers a callback to handle
  /// these messages, ensuring they are promptly displayed to all participants.
  /// This real-time feedback is essential for creating a dynamic conversation
  /// experience, allowing users to interact seamlessly as if they were conversing
  /// face-to-face.
  ///
  /// The `whenReceiveMessage` callback is at the heart of this function, designed
  /// to process and display incoming messages to the user. This can include
  /// updating the chat UI, playing notification sounds, or even triggering
  /// custom actions based on the content or type of the message received.
  ///
  /// Parameter:
  /// - `whenReceiveMessage`: A required callback function that is executed whenever
  ///   a new message is received in the chat room. It accepts dynamic data
  ///   representing the message, which could include the sender's details, message
  ///   content, timestamp, and potentially other metadata depending on the
  ///   application's requirements.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onReceiveMessageListener({
    required Function(ReceiveMessageModel receiveMessage) whenReceiveMessage,
    bool removeListener = false,
  }) {
    onReceiveMessage(
      socket: _socketService!,
      handler: whenReceiveMessage,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for message edits in a chat room.
  ///
  /// This function enhances the chat application's functionality by allowing users
  /// to see in real time when messages they've received or sent are edited. It's
  /// integral to maintaining the integrity and relevance of the conversation,
  /// ensuring that all participants have the most current information.
  ///
  /// Parameter:
  /// - `whenEditMessage`: A required callback function that is invoked whenever a
  ///   message is edited in the chat room. It receives dynamic data about the edited
  ///   message, such as its new content, the original content for reference, the
  ///   message ID, and the sender's details. This allows the application to update
  ///   the message in the UI, reflecting the changes made.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onEditMessageListener({
    required Function(EditedMessageModel editedMessage) whenEditMessage,
    bool removeListener = false,
  }) {
    onEditMessage(
      socket: _socketService!,
      handler: whenEditMessage,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for message deletions in a chat room.
  ///
  /// This function is vital for a clean and respectful chat environment, allowing
  /// users to be informed in real time when messages are removed from the conversation.
  /// It supports the dynamic nature of digital communication, where messages might
  /// need to be retracted or moderated.
  ///
  /// Parameter:
  /// - `whenDeleteMessage`: A required callback function that is triggered whenever
  ///   a message is deleted in the chat room. It receives dynamic data about the
  ///   deleted message, including the message ID and possibly the original message
  ///   content or sender's details, depending on the app's privacy policies. This
  ///   allows the app to remove the message from the UI and possibly inform the user.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onDeleteMessageListener({
    required Function(DeletedMessageModel deletedMessage) whenDeleteMessage,
    bool removeListener = false,
  }) {
    onDeleteMessage(
      socket: _socketService!,
      handler: whenDeleteMessage,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for typing indicators in a chat room.
  ///
  /// This function enriches the chat experience by signaling to users when others
  /// are composing a message in real time. It fosters a sense of immediacy and
  /// engagement, encouraging more lively and responsive conversations.
  ///
  /// Parameter:
  /// - `whenTyping`: A required callback function that is called when a user starts
  ///   typing in the chat room. It receives dynamic data indicating which user is
  ///   typing, allowing the application to display a typing indicator to other users.
  ///   This can help manage expectations and build anticipation for incoming messages.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onTypingListener({
    required Function(RoomFeedbackModel roomFeedback) whenTyping,
    bool removeListener = false,
  }) {
    onStartTyping(
      socket: _socketService!,
      handler: whenTyping,
      isRemove: removeListener,
    );
  }

  /// Sets up or removes a listener for when users stop typing in a chat room.
  ///
  /// This function complements the typing indicator by informing users when others
  /// have ceased typing, removing the typing indicator from the chat UI. It's essential
  /// for accurate communication cues, ensuring that users are not left expecting a
  /// message that is no longer being composed.
  ///
  /// Parameter:
  /// - `whenStoppedTyping`: A required callback function that is triggered when a user
  ///   stops typing in the chat room. It receives dynamic data about the user who has
  ///   stopped typing, allowing the application to update the UI accordingly and manage
  ///   user expectations about incoming messages.
  /// - `removeListener` (optional): A boolean value that, when set to true, instructs the function to
  ///   remove the set `whenStoppedTyping` listener. This is useful for cleaning up listeners
  ///   when they are no longer needed, such as when a user leaves a chat room or the application
  ///   wants to reduce the number of active listeners. The default value is false, indicating that
  ///   the listener should be set up rather than removed.
  void onStoppedTypingListener({
    required Function(RoomFeedbackModel roomFeedback) whenStoppedTyping,
    bool removeListener = false,
  }) {
    onStopTyping(
      socket: _socketService!,
      handler: whenStoppedTyping,
      isRemove: removeListener,
    );
  }

  /// Creates a new chat room with the specified [roomId].
  ///
  /// This streamlined function is essential for initiating new chat spaces within the application,
  /// allowing users to engage in conversations within specifically identified rooms. The uniqueness
  /// of the [roomId] is paramount to ensure each chat room is distinct and can be accurately
  /// referenced and accessed across the chat application.
  ///
  /// Parameter:
  /// - `roomId`: A unique String identifier for the new chat room. This ID is crucial for the room's
  ///   identification, ensuring messages and participants are correctly associated with the correct
  ///   chat space.
  void createRoom({
    required String roomId,
  }) {
    _mainValidator();
    if (roomId.isEmpty) {
      throw ArgumentError("Room ID cannot be empty.");
    }
    emitCreateRoom(
      socket: _socketService!,
      roomId: roomId,
    );
  }

  /// Deletes an existing chat room identified by [roomId].
  ///
  /// This function is key to managing the lifecycle of chat rooms within the application,
  /// allowing for the removal of rooms that are no longer active or needed. By specifying
  /// the [roomId], this operation ensures that the targeted chat space is accurately identified
  /// and removed, along with any associated data such as messages or participant lists.
  ///
  /// Parameter:
  /// - `roomId`: The unique String identifier for the chat room to be deleted. This ID ensures
  ///   that the correct room is targeted for deletion, maintaining the integrity of the chat
  ///   application's room management.
  void deleteRoom({
    required String roomId,
  }) {
    _mainValidator();
    if (roomId.isEmpty) {
      throw ArgumentError("Room ID cannot be empty.");
    }
    emitDeleteRoom(
      socket: _socketService!,
      roomId: roomId,
    );
  }

  /// Joins a user to a chat room identified by [roomId].
  ///
  /// This function facilitates the addition of a user to a specific chat room, enabling them to participate
  /// in conversations and receive messages in real time. The [roomId] identifies the target chat room,
  /// while the [username] uniquely identifies the user joining the room. This operation is essential for
  /// user interaction within the chat application, allowing for dynamic participation in various chat rooms.
  ///
  /// Parameters:
  /// - `roomId`: The unique String identifier for the chat room the user wishes to join. This ID ensures
  ///   that messages are directed to the correct conversation space.
  /// - `username`: The unique String representing the user joining the room. This could be a username or
  ///   any unique identifier associated with the user, facilitating user tracking and message attribution
  ///   within the room.
  void joinRoom({
    required String roomId,
    required String username,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitJoinRoom(
      socket: _socketService!,
      roomId: roomId,
      username: username,
    );
  }

  /// Removes a user from a chat room identified by [roomId].
  ///
  /// This function allows a user to exit a chat room, ceasing their participation in that room's conversations.
  /// It requires the [roomId] to specify which room the user intends to leave and the [username] to identify
  /// the departing user. This operation is crucial for managing user presence and ensuring that users can
  /// freely navigate between different chat spaces within the application.
  ///
  /// Parameters:
  /// - `roomId`: The unique String identifier for the chat room from which the user is leaving. This ensures
  ///   the correct room is updated upon the user's departure.
  /// - `username`: The unique String representing the user leaving the room. This could be a username or
  ///   any unique identifier for the user, used to remove the correct user from the room's participant list.
  void leaveRoom({
    required String roomId,
    required String username,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitLeaveRoom(
      socket: _socketService!,
      roomId: roomId,
      username: username,
    );
  }

  /// Sends a message to a specified chat room.
  ///
  /// This function allows users to send messages to a chat room, facilitating real-time
  /// communication among participants. The message can be of any type, such as a simple
  /// text string or a more complex JSON object, depending on the application's needs.
  ///
  /// Parameters:
  /// - `roomId`: The unique identifier of the chat room to which the message is being sent.
  /// - `username`: A unique identifier for the user sending the message. This should be a
  ///   unique string, such as a username or user ID, to properly attribute the message.
  /// - `message`: The content of the message being sent. This can be any object required by
  ///   the application, such as a string, JSON, etc.
  void sendMessage({
    required String roomId,
    required String username,
    required dynamic message,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitSendMessage(
      socket: _socketService!,
      roomId: roomId,
      username: username,
      message: message,
    );
  }

  /// Edits a previously sent message in a chat room.
  ///
  /// This function provides the capability to edit the content of a message that has already
  /// been sent, allowing users to correct errors or update information. The new message content
  /// can be any object, similar to sending a message, and is identified by a unique `messageId`.
  ///
  /// Parameters:
  /// - `roomId`: The unique identifier of the chat room containing the message to be edited.
  /// - `username`: A unique identifier for the user editing the message. This should match
  ///   the user who originally sent the message.
  /// - `messageId`: The unique identifier of the message being edited.
  /// - `newMessage`: The new content for the message, replacing the original message content.
  void editMessage({
    required String roomId,
    required String username,
    required String messageId,
    required dynamic newMessage,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitEditMessage(
      socket: _socketService!,
      roomId: roomId,
      username: username,
      messageId: messageId,
      newMessage: newMessage,
    );
  }

  /// Deletes a message from a chat room.
  ///
  /// This function enables users to remove a message from a chat room, whether for correcting
  /// mistakes, maintaining privacy, or any other reason. It requires identification of the message
  /// by its unique `messageId`, ensuring the correct message is targeted for deletion.
  ///
  /// Parameters:
  /// - `roomId`: The unique identifier of the chat room from which the message is being deleted.
  /// - `username`: A unique identifier for the user deleting the message. This should ideally
  ///   be the user who sent the message or a user with appropriate permissions.
  /// - `messageId`: The unique identifier of the message to be deleted.
  void deleteMessage({
    required String roomId,
    required String username,
    required String messageId,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitDeleteMessage(
      socket: _socketService!,
      roomId: roomId,
      username: username,
      messageId: messageId,
    );
  }

  /// Signals that a user has started typing in a specified chat room.
  ///
  /// This function is used to notify other participants in a chat room that a user
  /// has begun composing a message, enhancing the real-time interaction experience
  /// by indicating that a new message may soon be sent. It is essential for fostering
  /// an engaging and dynamic conversation environment.
  ///
  /// Parameters:
  /// - `roomId`: The unique identifier of the chat room where the typing activity is occurring.
  ///   This ID ensures that the typing indication is sent to the correct room.
  /// - `username`: A unique identifier for the user who has started typing. This should be a
  ///   unique string, such as a username or user ID, to properly attribute the typing activity
  ///   to the correct participant.
  void startTyping({
    required String roomId,
    required String username,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitStartTyping(
      socket: _socketService!,
      roomId: roomId,
      username: username,
    );
  }

  /// Signals that a user has stopped typing in a specified chat room.
  ///
  /// This function is used to notify other participants in a chat room that a user
  /// has ceased their typing activity, either because they have sent a message, decided
  /// not to send one, or are simply pausing their input. It helps manage expectations
  /// and maintains the accuracy of the conversation's dynamic status indicators.
  ///
  /// Parameters:
  /// - `roomId`: The unique identifier of the chat room where the typing activity has ceased.
  ///   This ID ensures that the stop typing indication is communicated to the correct room.
  /// - `username`: A unique identifier for the user who has stopped typing. As with starting
  ///   typing, this should be a unique string that accurately identifies the participant within
  ///   the chat environment.
  void stopTyping({
    required String roomId,
    required String username,
  }) {
    _validator(
      roomId: roomId,
      username: username,
    );
    emitStopTyping(
      socket: _socketService!,
      roomId: roomId,
      username: username,
    );
  }
}
