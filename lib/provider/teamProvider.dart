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

  // ✅ ฟังก์ชันอัปเดตอันดับทีม
  Future<void> updateTeamRanking(int teamID, String newRank) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index] = TeamItem(
        keyID: _teams[index].keyID,
        teamName: _teams[index].teamName,
        robotName: _teams[index].robotName,
        category: _teams[index].category,
        members: _teams[index].members,
        competitionDate: _teams[index].competitionDate,
        status: "จบการแข่งขัน", // ✅ เปลี่ยนสถานะอัตโนมัติ
        rank: newRank, // ✅ อัปเดตอันดับ
        imagePath: _teams[index].imagePath,
        score: _teams[index].score,
        votes: _teams[index].votes,
      );
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }

  // ✅ ฟังก์ชันอัปเดตคะแนนและอันดับพร้อมกัน
  Future<void> updateTeamData(int teamID, int newScore, String newRank) async {
    int index = _teams.indexWhere((team) => team.keyID == teamID);
    if (index != -1) {
      _teams[index] = TeamItem(
        keyID: _teams[index].keyID,
        teamName: _teams[index].teamName,
        robotName: _teams[index].robotName,
        category: _teams[index].category,
        members: _teams[index].members,
        competitionDate: _teams[index].competitionDate,
        status: "จบการแข่งขัน", // ✅ เปลี่ยนสถานะอัตโนมัติ
        rank: newRank, // ✅ อัปเดตอันดับ
        imagePath: _teams[index].imagePath,
        score: newScore, // ✅ อัปเดตคะแนนใหม่
        votes: _teams[index].votes,
      );
      await _db.updateTeam(_teams[index]);
      notifyListeners();
    }
  }
}
