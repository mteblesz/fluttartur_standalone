part of 'game_cubit.dart';

enum GameStatus {
  /// squad is being chosed
  squadChoice,

  /// squad is being voted on
  squadVoting,

  /// chosen squad votes in secret
  questVoting,

  /// quest resolved
  questResults,

  /// one of the teams has won
  gameResults,
}

enum QuestStatus {
  success,
  fail,
  ongoing,
  upcoming,
  error,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.squadChoice,
    this.questNumber = 1,
    this.lastQuestOutcome = false,
    this.questStatuses = const [
      QuestStatus.ongoing,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
    ],
    this.isSquadRequiredSize = false,
  });

  final GameStatus status;
  final int questNumber;
  final bool lastQuestOutcome;
  final List<QuestStatus> questStatuses;
  final bool isSquadRequiredSize;

  @override
  List<Object> get props => [
        status,
        questNumber,
        lastQuestOutcome,
        questStatuses,
        isSquadRequiredSize,
      ];

  GameState copyWith({
    GameStatus? status,
    int? questNumber,
    bool? lastQuestOutcome,
    List<QuestStatus>? questStatuses,
    bool? isSquadRequiredSize,
  }) {
    return GameState(
      status: status ?? this.status,
      questNumber: questNumber ?? this.questNumber,
      lastQuestOutcome: lastQuestOutcome ?? this.lastQuestOutcome,
      questStatuses: questStatuses ?? this.questStatuses,
      isSquadRequiredSize: isSquadRequiredSize ?? this.isSquadRequiredSize,
    );
  }

  List<QuestStatus> insertToQuestStatuses(QuestStatus status) {
    final statuses = questStatuses.toList(growable: false);
    statuses[questNumber - 1] = status;
    return statuses;
  }
}
