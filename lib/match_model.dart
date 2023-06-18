enum MatchStatus { scheduled, inProgress, finished }

enum Winner { teamA, teamB, draw, noWinner }

class MatchModel {
  String title;
  List teamAPlayers;
  List teamBPlayers;
  DateTime startTime;
  DateTime endTime;
  MatchStatus status;
  String teamAScore;
  String teamBScore;
  Winner winner;

  MatchModel({
    required this.title,
    required this.teamAPlayers,
    required this.teamBPlayers,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.teamAScore,
    required this.teamBScore,
    required this.winner,
  });

  factory MatchModel.fromJson1(data) {
    return MatchModel(
      title: data[0],
      teamAPlayers: data[1],
      teamBPlayers: data[2],
      startTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[3].toString())),
      endTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[4].toString())),
      status: MatchStatus.scheduled,
      winner: data[6] == "no winner"
          ? Winner.noWinner
          : data[6] == "TeamA"
              ? Winner.teamA
              : data[6] == 'TeamB'
                  ? Winner.teamB
                  : Winner.draw,
      teamAScore: data[7],
      teamBScore: data[8],
    );
  }
  factory MatchModel.fromJson2(data) {
    return MatchModel(
      title: data[0],
      teamAPlayers: data[1],
      teamBPlayers: data[2],
      startTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[3].toString())),
      endTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[4].toString())),
      status: MatchStatus.inProgress,
      winner: data[6] == "no winner"
          ? Winner.noWinner
          : data[6] == "TeamA"
              ? Winner.teamA
              : data[6] == 'TeamB'
                  ? Winner.teamB
                  : Winner.draw,
      teamAScore: data[7],
      teamBScore: data[8],
    );
  }
  factory MatchModel.fromJson3(data) {
    return MatchModel(
      title: data[0],
      teamAPlayers: data[1],
      teamBPlayers: data[2],
      startTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[3].toString())),
      endTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[4].toString())),
      status: MatchStatus.finished,
      winner: data[6] == "no winner"
          ? Winner.noWinner
          : data[6] == "TeamA"
              ? Winner.teamA
              : data[6] == 'TeamB'
                  ? Winner.teamB
                  : Winner.draw,
      teamAScore: data[7],
      teamBScore: data[8],
    );
  }
}
