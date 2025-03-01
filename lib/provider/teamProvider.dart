import 'package:flutter/material.dart';
import '../database/robotDB.dart';
import '../model/teamItem.dart';

class TeamProvider with ChangeNotifier {
  final RobotDB _db = RobotDB();
  List<TeamItem> _teams = [];

  List<TeamItem> get teams => _teams;

  Future<void> loadTeams({String? category}) async {
    _teams = await _db.getTeams(category: category);
    notifyListeners();
  }

  Future<void> addTeam(TeamItem team) async {
    int newID = await _db.insertTeam(team);
    team.keyID = newID;
    _teams.add(team);
    notifyListeners();
  }

  Future<void> updateTeam(TeamItem updatedTeam) async {
    await _db.updateTeam(updatedTeam);
    int index = _teams.indexWhere((team) => team.keyID == updatedTeam.keyID);
    if (index != -1) {
      _teams[index] = updatedTeam;
      notifyListeners();
    }
  }

  Future<void> deleteTeam(int teamID) async {
    await _db.deleteTeam(teamID);
    _teams.removeWhere((team) => team.keyID == teamID);
    notifyListeners();
  }

  Future<void> updateScore(int teamID, int newScore) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index].score = newScore;
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }

  Future<void> updateTeamData(int teamID, int newScore, String newRank) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index].score = newScore;
      _teams[index].rank = newRank;
      _teams[index].status = "จบการแข่งขัน";
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }

  // ✅ ฟังก์ชันโหวตทีมที่ชื่นชอบ
  Future<void> voteTeam(int teamID) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index].votes += 1;
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }
}
