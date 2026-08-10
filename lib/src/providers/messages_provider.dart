import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_chat/src/config/chat_config.dart';
import 'package:moe_flutter_chat/src/models/message_model.dart';
import 'package:moe_flutter_chat/src/models/chat_room_model.dart';

/// State for chat messages.
sealed class MessagesState {
  const MessagesState();
}

final class MessagesInitial extends MessagesState {}

final class MessagesLoaded extends MessagesState {
  final List<ChatMessageModel> messages;
  final bool isLoadingMore;
  const MessagesLoaded(this.messages, {this.isLoadingMore = false});
}

final class MessagesError extends MessagesState {
  final AppFailure failure;
  const MessagesError(this.failure);
}

/// Notifier for chat messages.
class MessagesNotifier extends StateNotifier<MessagesState> {
  final Ref _ref;

  MessagesNotifier(this._ref) : super(const MessagesInitial());

  Future<void> loadMessages(String roomId, {int limit = 50}) async {
    state = const MessagesLoading();

    // Mock implementation — replace with API + WebSocket when available
    await Future.delayed(Duration(milliseconds: 500));
    
    state = MessagesLoaded([]);
  }

  Future<void> sendMessage(String roomId, String content, {MessageType type = MessageType.text}) async {
    final message = ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      roomId: roomId,
      senderId: 0, // TODO: get from auth
      senderName: 'You',
      type: type,
      content: content,
      timestamp: DateTime.now(),
      isOwn: true,
    );

    if (state is MessagesLoaded) {
      final loaded = state as MessagesLoaded;
      state = MessagesLoaded([...loaded.messages, message]);
    } else {
      state = MessagesLoaded([message]);
    }

    // TODO: emit to WebSocket
  }

  void markAsRead(String roomId, String messageId) {
    // TODO: mark read API call
  }
}

/// Provider for MessagesNotifier.
final messagesProvider =
    StateNotifierProviderFactory<MessagesNotifier>((ref) {
  return MessagesNotifier(ref);
});
