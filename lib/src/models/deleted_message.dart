class DeletedMessageModel {
    final String userID;
    final String username;
    final String messageID;

    DeletedMessageModel({
      required this.userID,
      required this.username,
      required this.messageID,
    });

    @override
    String toString() {
      return 'DeletedMessage(userID: $userID, username: $username, messageID: $messageID)';
    }

  factory DeletedMessageModel.fromJson(Map<String, dynamic> json) {
    return DeletedMessageModel(
      userID: json['userID'],
      username: json['username'],
      messageID: json['messageID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'messageID': messageID,
    };
  }
}