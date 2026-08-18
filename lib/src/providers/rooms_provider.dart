import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_chat/src/models/chat_room_model.dart';

/// State for chat rooms.
sealed class RoomsState {
  const RoomsState();
}

final class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

final class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

final class RoomsLoaded extends RoomsState {
  final List<ChatRoomModel> rooms;
  const RoomsLoaded(this.rooms);
}

final class RoomsError extends RoomsState {
  final AppFailure failure;
  const RoomsError(this.failure);
}

/// Notifier for chat rooms.
class RoomsNotifier extends StateNotifier<RoomsState> {
  RoomsNotifier(Ref _) : super(const RoomsInitial());

  Future<void> loadRooms() async {
    state = const RoomsLoading();

    // Mock implementation — replace with API when available
    await Future.delayed(const Duration(milliseconds: 500));

    state = const RoomsLoaded([]);
  }

  ChatRoomModel? getRoomById(String roomId) {
    if (state is! RoomsLoaded) return null;
    final rooms = (state as RoomsLoaded).rooms;
    return rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => throw Exception('Room not found'),
    );
  }

  int get totalUnreadCount {
    if (state is! RoomsLoaded) return 0;
    return (state as RoomsLoaded)
        .rooms
        .fold<int>(0, (sum, room) => sum + room.unreadCount);
  }
}

/// Provider for RoomsNotifier.
final roomsProvider = StateNotifierProvider<RoomsNotifier, RoomsState>((ref) {
  return RoomsNotifier(ref);
});
