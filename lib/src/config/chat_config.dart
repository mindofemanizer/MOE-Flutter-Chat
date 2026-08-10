import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chat feature flags — modular configuration.
class ChatFeatures {
  final bool enableSimpleChat; // buyer-seller only
  final bool enableGroupChat;
  final bool enableVoiceCall;
  final bool enableVideoCall;
  final bool enableChannelBroadcast;

  const ChatFeatures({
    this.enableSimpleChat = true,
    this.enableGroupChat = false,
    this.enableVoiceCall = false,
    this.enableVideoCall = false,
    this.enableChannelBroadcast = false,
  });

  bool get isFull => 
    enableSimpleChat && 
    enableGroupChat && 
    enableVoiceCall && 
    enableVideoCall && 
    enableChannelBroadcast;
}

/// Configuration for MOE Chat package.
class MoeChatConfig {
  final String apiUrl;
  final String wsUrl;
  final ChatFeatures features;

  const MoeChatConfig({
    required this.apiUrl,
    required this.wsUrl,
    this.features = const ChatFeatures(),
  });
}

/// Provider for chat config.
final chatConfigProvider = Provider<MoeChatConfig>((ref) {
  throw UnimplementedError('MoeChat.setup() must be called before use.');
});

/// Setup function — call in main() before runApp().
///
/// ```dart
/// void main() {
///   MoeChat.setup(
///     config: MoeChatConfig(
///       apiUrl: 'https://api.halosapa.com/api/chat',
///       wsUrl: 'wss://api.halosapa.com/ws/chat',
///       features: ChatFeatures(enableGroupChat: true),
///     ),
///   );
///   runApp(const ProviderScope(child: MyApp()));
/// }
/// ```
class MoeChat {
  static late MoeChatConfig _config;

  static void setup({required MoeChatConfig config}) {
    _config = config;
  }

  static MoeChatConfig get config => _config;

  static ChatFeatures get features => _config.features;
}
