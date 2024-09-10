class ReceiveMessageModel {
  final String userID;
  final String username;
  final dynamic messageData;

  ReceiveMessageModel({
    required this.userID,
    required this.username,
    required this.messageData,
  });

  @override
  String toString() {
    return 'ReceiveMessage(userID: $userID, username: $username, messageData: $messageData)';
  }

  factory ReceiveMessageModel.fromJson(Map<String, dynamic> json) {
    return ReceiveMessageModel(
      userID: json['userID'],
      username: json['username'],
      messageData: json['messageData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'messageData': messageData,
    };
  }
}



