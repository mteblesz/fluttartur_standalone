import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

//TODO divide models and DTOs (?)

class Player extends Equatable {
  const Player({
    this.id = '',
    required this.userId,
    required this.nick,
    required this.isLeader,
    required this.isAI,
    this.character,
    this.specialCharacter,
  });

  final String id;
  final String userId;
  final String nick;
  final bool isLeader;
  final bool isAI;
  final String? character; // TODO Change to boolean
  final String? specialCharacter;

  /// Empty player which represents that user is currently not in any player.
  static const empty =
      Player(userId: '', nick: '', isLeader: false, isAI: false);

  /// Convenience getter to determine whether the current player is empty.
  bool get isEmpty => this == Player.empty;

  /// Convenience getter to determine whether the current player is not empty.
  bool get isNotEmpty => this != Player.empty;

  @override
  List<Object?> get props =>
      [id, userId, nick, isLeader, character, specialCharacter];

  factory Player.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Player(
      id: doc.id,
      userId: data?["user_id"],
      nick: data?['nick'],
      isLeader: data?['is_leader'],
      isAI: data?['is_ai'],
      character: data?['character'],
      specialCharacter: data?['special_character'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_id": userId,
      "nick": nick,
      'is_leader': isLeader,
      'is_ai': isAI,
      if (character != null) "character": character,
      if (specialCharacter != null) "special_character": specialCharacter,
    };
  }
}
