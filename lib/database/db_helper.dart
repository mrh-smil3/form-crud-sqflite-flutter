import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/mahasiswa.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  //inisiasi tabel yang dibutuhkan
  final String tableName = 'tableMhs';
  final String columnId = 'id';
  final String columnNama = 'nama';
  final String columnNim = 'nim';
  final String columnEmail = 'email';
  final String columnProdi = 'prodi';

  DbHelper._internal();
  factory DbHelper() => _instance;

  //cek database
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'mhs.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel
  Future<void> _onCreate(Database db, int version) async {
    var sql = 'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,'
        '$columnNama TEXT,'
        '$columnNim TEXT,'
        '$columnEmail TEXT,'
        '$columnProdi TEXT)';
    await db.execute(sql);
  }

  //insert
  Future<int?> saveMhs(Mahasiswa mhs) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, mhs.toMap());
  }

  //read
  Future<List?> getAllMhs() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName,
        columns: [columnId, columnNama, columnProdi, columnNim, columnEmail]);
    return result.toList();
  }

  //update
  Future<int?> updateMhs(Mahasiswa mhs) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, mhs.toMap(),
        where: '$columnId = ?', whereArgs: [mhs.id]);
  }

  //delete
  Future<int?> deleteMhs(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
