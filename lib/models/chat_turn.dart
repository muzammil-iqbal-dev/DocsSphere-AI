import 'doc.dart';

/// Represents one turn in the AI assistant chat history.
class ChatTurn {
  ChatTurn(this.user, this.text, {this.source});
  final bool user;
  final String text;
  final Doc? source;
}
