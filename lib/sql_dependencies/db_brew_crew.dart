import 'dart:async';
import 'dart:io';

import 'package:brew_crew/models/coffee_drink.dart';
import 'package:brew_crew/sql_dependencies/types.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BrewCrewDatabase  {
  BrewCrewDatabase._initialize();
  static final BrewCrewDatabase instance = BrewCrewDatabase._initialize();
  static const String _dbName = "brew_crew.db";
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initializeDatabase();
    return _db!;
  }

  Future<Database> _initializeDatabase() async {
    print('inside initialize database');
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      print("path verification error : " + e.toString());
    }
    return await openDatabase(path, version: 1, onCreate: _configureDatabase);
  }

  // onCreate takes two predefined arguments, the database and the version.
  FutureOr<void> _configureDatabase(Database db, int version) async {
    print('inside configure database');
    createTableCoffeeDrinks(db);
    print('table coffee drinks created ');

    insert(db);
  }

  Future<void> createTableCoffeeDrinks(Database db) async {
    await db.execute('''
      CREATE TABLE ${CoffeeDrinkSql.table} (
        ${CoffeeDrinkSql.id} ${FieldTypes.idTypeAT},
        ${CoffeeDrinkSql.name} ${FieldTypes.textType},
        ${CoffeeDrinkSql.img} ${FieldTypes.textType},
        ${CoffeeDrinkSql.price} ${FieldTypes.doubleType},
        ${CoffeeDrinkSql.calories} ${FieldTypes.doubleType}
      )
      ''');
  }

  Future<void> insert(Database db) async {
    for (var drink in CoffeeDrinkLocalInfo.data) {
      await db.insert(CoffeeDrinkSql.table, drink.toJson());
      print('insert succss');
    }
  }

  Future<List<CoffeeDrink>> get(Database db) async {
    List<Map<String, Object?>> result = await db.query(CoffeeDrinkSql.table);
    if (result.isNotEmpty) {
      print("success");
      return result.map((e) => CoffeeDrink.fromJson(e)).toList();
    } else {
      print("data not found" + result.toString());
      return [];
    }
  }

  Future<void> deleteAllRows(String tableName) async {
    Database db = await instance.database;
    await db.delete(tableName);
    print("all rows inside table $tableName have been deleted");
  }

  Future<void> close() async {
    Database db = await instance.database;
    db.close();
  }
}
