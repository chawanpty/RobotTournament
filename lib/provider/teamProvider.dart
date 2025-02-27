import 'package:flutter/material.dart';
import '../database/robotDB.dart';
import '../model/teamItem.dart';

class TeamProvider with ChangeNotifier {
  final RobotDB _db = RobotDB();
  List<TeamItem> _teams = [];

  List<TeamItem> get teams => _teams;

  // ✅ โหลดทีมตามประเภท (ถ้ามี category)
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

  Future<void> updateVotes(int teamID) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index].votes += 1;
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }

  // ✅ ค้นหาทีมจากชื่อ
  List<TeamItem> searchTeams(String query) {
    return _teams
        .where(
            (team) => team.teamName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // ✅ กรองทีมตามคะแนนสูงสุด หรือโหวตสูงสุด
  List<TeamItem> filterTeams(String filterType) {
    List<TeamItem> sortedTeams = List.from(_teams);
    if (filterType == "คะแนนสูงสุด") {
      sortedTeams.sort((a, b) => b.score.compareTo(a.score));
    } else if (filterType == "โหวตสูงสุด") {
      sortedTeams.sort((a, b) => b.votes.compareTo(a.votes));
    }
    return sortedTeams;
  }

  // ✅ รีเซ็ตคะแนนทั้งหมด
  Future<void> resetScores() async {
    for (var team in _teams) {
      team.score = 0;
      await _db.updateTeam(team);
    }
    notifyListeners();
  }
}
