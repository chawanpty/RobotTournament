import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../model/teamItem.dart';

class RobotDB {
  Database? _db;

  Future<Database> openDatabase() async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, 'robot_tournament.db');
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
    return _db!;
  }

  Future<void> closeDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  Future<List<TeamItem>> getTeams({String? category}) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('robot_teams');

    var finder = category != null
        ? Finder(filter: Filter.equals('category', category))
        : null;

    var snapshots = await store.find(db, finder: finder);
    return snapshots.map((snapshot) {
      return TeamItem.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  Future<int> insertTeam(TeamItem team) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('robot_teams');
    int id = await store.add(db, team.toMap());
    await closeDatabase();
    return id;
  }

  Future<void> updateTeam(TeamItem team) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('robot_teams');

    await store.update(
      db,
      team.toMap(),
      finder: Finder(filter: Filter.equals(Field.key, team.keyID)),
    );

    await closeDatabase();
  }

  Future<void> deleteTeam(int teamID) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('robot_teams');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, teamID)));
    await closeDatabase();
  }
}
