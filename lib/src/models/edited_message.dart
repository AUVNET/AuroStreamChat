class EditedMessageModel {
  final String userID;
  final String username;
  final String messageID;
  final dynamic messageData;

  EditedMessageModel({
    required this.userID,
    required this.username,
    required this.messageID,
    required this.messageData,
  });

  @override
  String toString() {
    return 'EditedMessage(userID: $userID, username: $username, messageID: $messageID, messageData: $messageData)';
  }

  factory EditedMessageModel.fromJson(Map<String, dynamic> json) {
    return EditedMessageModel(
      userID: json['userID'],
      username: json['username'],
      messageID: json['messageID'],
      messageData: json['messageData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'messageID': messageID,
      'messageData': messageData,
    };
  }
}