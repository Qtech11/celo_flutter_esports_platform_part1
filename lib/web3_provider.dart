import 'package:flutter/material.dart';
import 'package:flutter_celo_esports_platform/web3_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'match_model.dart';

enum Status { init, loading, done }

final web3Provider = ChangeNotifierProvider((ref) => Web3Provider());

class Web3Provider extends ChangeNotifier {
  List<MatchModel> scheduledMatchList = [];
  List<MatchModel> inProgressMatchList = [];
  List<MatchModel> finishedMatchList = [];

  Status getAllMatchesStatus = Status.init;
  Status createMatchStatus = Status.init;
  Status updateTeamAStatus = Status.init;
  Status updateTeamBStatus = Status.init;
  Status removePlayerStatus = Status.init;
  Status updateMatchStatusStatus = Status.init;
  Status updateMatchScoreStatus = Status.init;
  Status updateMatchWinnerStatus = Status.init;

  Future<void> getAllMatches() async {
    try {
      getAllMatchesStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().getAllMatches();
      if (response != null) {
        List<MatchModel> scheduledList = [];
        List<MatchModel> progressList = [];
        List<MatchModel> finishedList = [];
        for (final data in response[0]) {
          if (data[5] == 'Scheduled') {
            scheduledList.add(MatchModel.fromJson1(data));
          } else if (data[5] == 'In Progress') {
            progressList.add(MatchModel.fromJson2(data));
          } else {
            finishedList.add(MatchModel.fromJson3(data));
          }
        }
        scheduledMatchList = scheduledList;
        inProgressMatchList = progressList;
        finishedMatchList = finishedList;
      }
      getAllMatchesStatus = Status.done;
      notifyListeners();
    } catch (e) {
      getAllMatchesStatus = Status.done;
      notifyListeners();
      print(e);
    }
  }

  void createMatch(
      String title, int startTime, int endTime, BuildContext context) async {
    try {
      createMatchStatus = Status.loading;
      notifyListeners();
      final response =
          await Web3Helper().createMatch(title, startTime, endTime);
      if (response != null) {
        await getAllMatches();
      }
      createMatchStatus = Status.done;
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      createMatchStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> updateTeamA(
      String matchTitle, List<String> players, BuildContext context) async {
    try {
      updateTeamAStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().updateTeamA(matchTitle, players);
      print(response);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      updateTeamAStatus = Status.done;
      notifyListeners();
    } catch (e) {
      updateTeamAStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> updateTeamB(
      String matchTitle, List<String> players, BuildContext context) async {
    try {
      updateTeamBStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().updateTeamB(matchTitle, players);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      updateTeamBStatus = Status.done;
      notifyListeners();
    } catch (e) {
      updateTeamBStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> removePlayer(
      String matchTitle, String playerName, bool isTeamA, context) async {
    try {
      removePlayerStatus = Status.loading;
      notifyListeners();
      final response =
          await Web3Helper().removePlayer(matchTitle, playerName, isTeamA);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      removePlayerStatus = Status.done;
      notifyListeners();
    } catch (e) {
      removePlayerStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> updateMatchStatus(
      String matchTitle, String status, context) async {
    try {
      updateMatchStatusStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().updateMatchStatus(matchTitle, status);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      updateMatchStatusStatus = Status.done;
      notifyListeners();
    } catch (e) {
      updateMatchStatusStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> updateMatchScore(
      String matchTitle, String teamAScore, String teamBScore, context) async {
    try {
      updateMatchScoreStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper()
          .updateMatchScore(matchTitle, teamAScore, teamBScore);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      updateMatchScoreStatus = Status.done;
      notifyListeners();
    } catch (e) {
      updateMatchScoreStatus = Status.done;
      notifyListeners();
    }
  }

  Future<void> updateMatchWinner(
      String matchTitle, String winner, context) async {
    try {
      updateMatchWinnerStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().updateMatchWinner(matchTitle, winner);
      if (response != null) {
        await getAllMatches();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      updateMatchWinnerStatus = Status.done;
      notifyListeners();
    } catch (e) {
      updateMatchWinnerStatus = Status.done;
      notifyListeners();
    }
  }
}
