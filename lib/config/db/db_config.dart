import 'package:restaurant_app/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DBConfig {
  static DBConfig? _dbConfig;
  static late Database _database;

  DBConfig._internal() {
    _dbConfig = this;
  }

  factory DBConfig() => _dbConfig ?? DBConfig._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      "$path/restaurant.db",
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE Favorites (
               id TEXT PRIMARY KEY,
               name TEXT,
               description TEXT,
               pictureId TEXT,
               city TEXT,
               rating REAL
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insert(Restaurant restaurant) async {
    var db = await database;
    var value = {
      "id": restaurant.id,
      "name": restaurant.name,
      "description": restaurant.description,
      "pictureId": restaurant.pictureId,
      "city": restaurant.city,
      "rating": restaurant.rating,
    };
    await db.insert("Favorites", value);
  }

  Future<List<Restaurant>> getFavoritesRestaurant() async {
    var db = await database;
    List<Map<String, dynamic>> result = await db.query("Favorites");
    return result.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Restaurant> getFavoriteRestaurantById(String id) async {
    var db = await database;
    var result = await db.query("Favorites", where: "id = ?", whereArgs: [id]);
    return Restaurant.fromJson(result.first);
  }

  Future<void> remove(String id) async {
    var db = await database;
    await db.delete("Favorites", where: "id = ?", whereArgs: [id]);
  }
}