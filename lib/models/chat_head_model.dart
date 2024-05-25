class ChatHead {
  final String roomID;
  final DateTime timestamp;
  final String remoteName;
  final String remoteID;
  final String remoteImage;
  final String lastMessage;
  final String lastMessageType;

  ChatHead({
    required this.roomID,
    required this.timestamp,
    required this.remoteName,
    required this.remoteID,
    required this.remoteImage,
    required this.lastMessage,
    required this.lastMessageType,
  });

  factory ChatHead.fromJson(Map<String, dynamic> json) {
    return ChatHead(
      roomID: json['roomID'],
      timestamp: json['timestamp'].toDate(),
      remoteName: json['remoteName'],
      remoteID: json['remoteID'],
      remoteImage: json['remoteImage'],
      lastMessage: json['lastMessage'],
      lastMessageType: json['lastMessageType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'timestamp': timestamp,
      'remoteName': remoteName,
      'remoteID': remoteID, // Added this line
      'remoteImage': remoteImage,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
    };
  }
}
