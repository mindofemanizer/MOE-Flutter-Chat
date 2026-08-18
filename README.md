# MOE-Flutter-Chat

Chat package for MOE Flutter ecosystem — modular: simple buyer-seller / full (group, call, channel).

## Installation

```yaml
dependencies:
  moe_flutter_chat:
    git:
      url: https://github.com/mindofemanizer/MOE-Flutter-Chat.git
      ref: master
```

## Usage

### Setup Buyer-Seller Only (Kioskit)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await MoeFoundation.setup(
    envConfig: EnvConfig.fromEnvironment(),
    sharedPreferences: prefs,
  );

  MoeChat.setup(
    config: MoeChatConfig(
      apiUrl: 'https://api.kioskit.com/api/chat',
      wsUrl: 'wss://api.kioskit.com/ws/chat',
      features: ChatFeatures(
        enableSimpleChat: true, // buyer-seller only
        enableGroupChat: false,
        enableVoiceCall: false,
        enableVideoCall: false,
        enableChannelBroadcast: false,
      ),
    ),
  );

  runApp(MoeFoundationProviderScope(child: MyApp()));
}
```

### Setup Full Chat (HaloSapa)

```dart
MoeChat.setup(
  config: MoeChatConfig(
    apiUrl: 'https://api.halosapa.com/api/chat',
    wsUrl: 'wss://api.halosapa.com/ws/chat',
    features: ChatFeatures(
      enableSimpleChat: true,
      enableGroupChat: true,
      enableVoiceCall: true,
      enableVideoCall: true,
      enableChannelBroadcast: true,
    ),
  ),
);
```

### Load Rooms

```dart
final roomsState = ref.watch(roomsProvider);

switch (roomsState) {
  case RoomsLoaded(:final rooms):
    ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (ctx, i) => ListTile(
        title: Text(rooms[i].name),
        subtitle: Text(rooms[i].lastMessage ?? ''),
        trailing: rooms[i].unreadCount > 0
            ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Text('${rooms[i].unreadCount}', style: TextStyle(color: Colors.white, fontSize: 10)),
              )
            : null,
      ),
    );
  default:
    // loading/error
}

// trigger load
ref.read(roomsProvider.notifier).loadRooms();

// get total unread
final totalUnread = ref.read(roomsProvider.notifier).totalUnreadCount;
```

### Send Message

```dart
final roomId = 'room_123';
ref.read(messagesProvider(roomId).notifier).sendMessage(
  roomId,
  'Hello from KiosKit customer!',
  type: MessageType.text,
);
```

## What's Included

| Module | Description |
|--------|-------------|
| `ChatFeatures` | Modular configuration (simple/group/calls/channel) |
| `ChatMessageModel` | Messages with 6 types |
| `ChatRoomModel` | Rooms (buyer-seller, group, broadcast) |
| `MessagesNotifier` | Load/send/mark as read |
| `RoomsNotifier` | List + unread count |
