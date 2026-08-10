/// Chat room data model.
class ChatRoomModel {
  final String id;
  final String name;
  final String? description;
  final String type; // simple, group, channel
  final List<String> participants; // user IDs
  final int unreadCount;
  final DateTime lastMessageAt;
  final String? lastMessage;
  final bool isTyping;

  const ChatRoomModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.participants,
    this.unreadCount = 0,
    required this.lastMessageAt,
    this.lastMessage,
    this.isTyping = false,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      participants: (json['participants'] as List<dynamic>)
          .whereType<String>()
          .toList(),
      unreadCount: json['unread_count'] as int? ?? 0,
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      lastMessage: json['last_message'] as String?,
      isTyping: json['is_typing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        'type': type,
        'participants': participants,
        'unread_count': unreadCount,
        'last_message_at': lastMessageAt.toIso8601String(),
        if (lastMessage != null) 'last_message': lastMessage,
        'is_typing': isTyping,
      };

  ChatRoomModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    List<String>? participants,
    int? unreadCount,
    DateTime? lastMessageAt,
    String? lastMessage,
    bool? isTyping,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessage: lastMessage ?? this.lastMessage,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  bool get isSimpleChat => type == 'simple';
  bool get isGroup => type == 'group';
  bool get isChannel => type == 'channel';
}
