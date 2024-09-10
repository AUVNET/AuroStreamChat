class RoomManagementModel {
  final String roomID;

  RoomManagementModel({
    required this.roomID,
  });

  @override
  String toString() {
    return 'RoomManagement(roomID: $roomID)';
  }

  factory RoomManagementModel.fromJson(Map<String, dynamic> json) {
    return RoomManagementModel(
      roomID: json['roomID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
    };
  }
}