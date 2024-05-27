import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;
  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await getDb();
    return _database!;
  }

  Future<Database> getDb() async {
    String path =
    join(await getDatabasesPath(), 'kobra.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate:  _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)');
    await db.execute('CREATE TABLE purchases(id INTEGER PRIMARY KEY AUTOINCREMENT, userid INTEGER, vehicle TEXT, date_arrival TEXT)');
  }

  Future<int> insertUser(String username, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> check(String username, String password) async {
    final db = await database;
    final response = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [username,password]);

    return response.isNotEmpty ? response.first : null;
  }

  Future<int> insertPurchases(int userId, String vehicle, String dateArrival) async {
    final db = await database;
    return await db.insert('purchases', {
      'userid': userId,
      'vehicle': vehicle,
      'date_arrival': dateArrival,
    });
  }

  Future<List<Map<String, dynamic>>?> getPurchases(int userId) async {
    final db = await database;
    final response = await db.query('purchases',
        where: 'userid = ?',
        whereArgs: [userId]);

    if(response.isNotEmpty) return response;
    return null;
  }
}