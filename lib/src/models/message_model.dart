/// Message type enum.
enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  system;

  /// Icon label for display.
  IconData? get iconData {
    switch (this) {
      case MessageType.text:
        return Icons.message_outlined;
      case MessageType.image:
        return Icons.image_outlined;
      case MessageType.video:
        return Icons.videocam_outlined;
      case MessageType.audio:
        return Icons.mic_outlined;
      case MessageType.file:
        return Icons.insert_drive_file_outlined;
      case MessageType.system:
        return Icons.info_outline;
    }
  }
}

/// Chat message data model.
class ChatMessageModel {
  final String id;
  final String roomId;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String content;
  final Map<String, dynamic>? mediaMetadata;
  final DateTime timestamp;
  final DateTime? readAt;
  final bool isOwn;

  const ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.content,
    this.mediaMetadata,
    required this.timestamp,
    this.readAt,
    this.isOwn = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as int,
      senderName: json['sender_name'] as String,
      senderAvatar: json['sender_avatar'] as String?,
      type: switch (json['type']) {
        'image' => MessageType.image,
        'video' => MessageType.video,
        'audio' => MessageType.audio,
        'file' => MessageType.file,
        'system' => MessageType.system,
        _ => MessageType.text,
      },
      content: json['content'] as String,
      mediaMetadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      isOwn: json['is_own'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'sender_id': senderId,
        'sender_name': senderName,
        if (senderAvatar != null) 'sender_avatar': senderAvatar,
        'type': switch (type) {
          MessageType.text => 'text',
          MessageType.image => 'image',
          MessageType.video => 'video',
          MessageType.audio => 'audio',
          MessageType.file => 'file',
          MessageType.system => 'system',
        },
        'content': content,
        if (mediaMetadata != null) 'metadata': mediaMetadata,
        'created_at': timestamp.toIso8601String(),
        if (readAt != null) 'read_at': readAt!.toIso8601String(),
        'is_own': isOwn,
      };

  ChatMessageModel copyWith({
    String? id,
    String? roomId,
    int? senderId,
    String? senderName,
    String? senderAvatar,
    MessageType? type,
    String? content,
    Map<String, dynamic>? mediaMetadata,
    DateTime? timestamp,
    DateTime? readAt,
    bool? isOwn,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaMetadata: mediaMetadata ?? this.mediaMetadata,
      timestamp: timestamp ?? this.timestamp,
      readAt: readAt ?? this.readAt,
      isOwn: isOwn ?? this.isOwn,
    );
  }

  bool get isRead => readAt != null;
  bool get isSystem => type == MessageType.system;
}
