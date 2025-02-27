class TeamItem {
  int? keyID;
  String teamName;
  String robotName;
  String category;
  List<String> members;
  String? competitionDate;
  String status;
  String rank;
  String imagePath;
  int score;
  int votes;

  TeamItem({
    this.keyID,
    required this.teamName,
    required this.robotName,
    required this.category,
    required this.members,
    this.competitionDate,
    this.status = "กำลังแข่งขัน",
    this.rank = "กำลังแข่งขัน",
    required this.imagePath,
    this.score = 0,
    this.votes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
      'robotName': robotName,
      'category': category,
      'members': members,
      'competitionDate': competitionDate ?? '',
      'status': status,
      'rank': rank,
      'imagePath': imagePath,
      'score': score,
      'votes': votes,
    };
  }

  factory TeamItem.fromMap(int key, Map<String, dynamic> map) {
    return TeamItem(
      keyID: key,
      teamName: map['teamName'],
      robotName: map['robotName'],
      category: map['category'],
      members: List<String>.from(map['members']),
      competitionDate: map['competitionDate'] ?? '',
      status: map['status'],
      rank: map['rank'],
      imagePath: map['imagePath'],
      score: map['score'] ?? 0,
      votes: map['votes'] ?? 0,
    );
  }
}
