# Changelog

## 1.0.0 — 2026-08-10

### Added
- Initial release
- `ChatFeatures` — modular feature flags (simple, group, voice/video call, channel)
- `ChatMessageModel` — message data model with types (text, image, video, audio, file, system)
- `ChatRoomModel` — room data model (simple, group, channel)
- `MessagesNotifier` — load/send messages state management
- `RoomsNotifier` — list rooms + unread count
- `MoeChatConfig` — configurable API + WebSocket URLs
- `MoeChat.setup()` — entry point
- Riverpod providers: `messagesProvider`, `roomsProvider`
