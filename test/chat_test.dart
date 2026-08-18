import 'package:flutter_test/flutter_test.dart';
import 'package:moe_flutter_chat/moe_flutter_chat.dart';

void main() {
  group('MessageType', () {
    test('has iconData for all types', () {
      expect(MessageType.text.iconData, isNotNull);
      expect(MessageType.image.iconData, isNotNull);
      expect(MessageType.video.iconData, isNotNull);
      expect(MessageType.audio.iconData, isNotNull);
      expect(MessageType.file.iconData, isNotNull);
      expect(MessageType.system.iconData, isNotNull);
    });
  });

  group('ChatMessageModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'msg1',
        'room_id': 'room1',
        'sender_id': 10,
        'sender_name': 'Test User',
        'type': 'image',
        'content': 'image_url_here.jpg',
        'metadata': {'width': 800, 'height': 600},
        'created_at': '2026-08-10T14:30:00.000Z',
        'read_at': '2026-08-10T14:31:00.000Z',
        'is_own': false,
      };

      final msg = ChatMessageModel.fromJson(json);

      expect(msg.id, equals('msg1'));
      expect(msg.roomId, equals('room1'));
      expect(msg.senderId, equals(10));
      expect(msg.type, equals(MessageType.image));
      expect(msg.timestamp.year, equals(2026));
      expect(msg.readAt, isNotNull);
      expect(msg.isOwn, isFalse);
      expect(msg.isRead, isTrue);
    });

    test('toJson round-trips correctly', () {
      final model = ChatMessageModel(
        id: 'test',
        roomId: 'r1',
        senderId: 1,
        senderName: 'Me',
        type: MessageType.text,
        content: 'Hello',
        timestamp: DateTime(2026, 8, 10, 14, 30),
        isOwn: true,
      );

      final json = model.toJson();

      expect(json['id'], equals('test'));
      expect(json['content'], equals('Hello'));
      expect(json['sender_id'], equals(1));
      expect(json['is_own'], isTrue);
    });

    test('copyWith updates fields', () {
      final original = ChatMessageModel(
        id: 'test',
        roomId: 'r1',
        senderId: 1,
        senderName: 'Me',
        type: MessageType.text,
        content: 'Old',
        timestamp: DateTime(2026, 8, 10),
      );

      final updated = original.copyWith(content: 'New', readAt: DateTime.now());

      expect(updated.content, equals('New'));
      expect(updated.isRead, isTrue);
    });

    test('isSystem returns true for system type', () {
      final model = ChatMessageModel(
        id: 'test',
        roomId: 'r1',
        senderId: 0,
        senderName: 'System',
        type: MessageType.system,
        content: 'You joined the chat',
        timestamp: DateTime(2026, 8, 10),
      );

      expect(model.isSystem, isTrue);
    });
  });

  group('ChatRoomModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'room1',
        'name': 'Store Chat',
        'description': 'Customer support chat',
        'type': 'simple',
        'participants': ['1', '10'],
        'unread_count': 5,
        'last_message_at': '2026-08-10T15:00:00.000Z',
        'last_message': 'Thank you!',
        'is_typing': false,
      };

      final room = ChatRoomModel.fromJson(json);

      expect(room.id, equals('room1'));
      expect(room.name, equals('Store Chat'));
      expect(room.description, equals('Customer support chat'));
      expect(room.type, equals('simple'));
      expect(room.participants, equals(['1', '10']));
      expect(room.unreadCount, equals(5));
      expect(room.lastMessage, equals('Thank you!'));
      expect(room.isSimpleChat, isTrue);
      expect(room.isGroup, isFalse);
      expect(room.isChannel, isFalse);
    });

    test('toJson round-trips correctly', () {
      final model = ChatRoomModel(
        id: 'test',
        name: 'Test Room',
        type: 'simple',
        participants: ['user1'],
        lastMessageAt: DateTime(2026, 8, 10),
      );

      final json = model.toJson();

      expect(json['id'], equals('test'));
      expect(json['type'], equals('simple'));
      expect(json['participants'].length, equals(1));
    });

    test('default values', () {
      final model = ChatRoomModel(
        id: 'test',
        name: 'Test',
        type: 'simple',
        participants: [],
        lastMessageAt: DateTime(2026, 8, 10),
      );

      expect(model.unreadCount, equals(0));
      expect(model.lastMessage, isNull);
      expect(model.isTyping, isFalse);
    });
  });

  group('MoeChatConfig', () {
    test('requires apiUrl and wsUrl', () {
      const config = MoeChatConfig(
        apiUrl: 'https://api.example.com/chat',
        wsUrl: 'wss://api.example.com/ws/chat',
      );

      expect(config.apiUrl, equals('https://api.example.com/chat'));
      expect(config.wsUrl, equals('wss://api.example.com/ws/chat'));
      expect(config.features.enableSimpleChat, isTrue);
      expect(config.features.enableGroupChat, isFalse);
    });

    test('full feature set', () {
      const config = MoeChatConfig(
        apiUrl: 'https://api.example.com/chat',
        wsUrl: 'wss://api.example.com/ws/chat',
        features: ChatFeatures(
          enableSimpleChat: true,
          enableGroupChat: true,
          enableVoiceCall: true,
          enableVideoCall: true,
          enableChannelBroadcast: true,
        ),
      );

      expect(config.features.isFull, isTrue);
    });
  });

  group('ChatFeatures', () {
    test('default enables simple chat only', () {
      const features = ChatFeatures();

      expect(features.enableSimpleChat, isTrue);
      expect(features.enableGroupChat, isFalse);
      expect(features.isFull, isFalse);
    });

    test('can enable specific features', () {
      const features = ChatFeatures(
        enableSimpleChat: true,
        enableGroupChat: true,
      );

      expect(features.enableSimpleChat, isTrue);
      expect(features.enableGroupChat, isTrue);
      expect(features.isFull, isFalse);
    });
  });
}
