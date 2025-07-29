import 'dart:async';

import 'package:core/core.dart';
import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      password: encrypt('umapyoi densetsu'),
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        no INTEGER PRIMARY KEY AUTOINCREMENT,
        id INTEGER NOT NULL,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        type TEXT CHECK(type IN ('movie', 'tv')) DEFAULT 'movie'
      );
    ''');
  }

  Future<int> insertMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> insertTvWatchlist(TVTable tv) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, tv.toJson());
  }

  Future<int> removeMovieWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [movie.id, 'movie'],
    );
  }

  Future<int> removeTvWatchlist(TVTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [tv.id, 'tv'],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'movie'],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND type = ?',
      whereArgs: [id, 'tv'],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = ?',
      whereArgs: ['movie'],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = ?',
      whereArgs: ['tv'],
    );

    return results;
  }
}
