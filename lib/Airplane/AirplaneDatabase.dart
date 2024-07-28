


import 'dart:async';

import 'package:floor/floor.dart';
import 'package:cst2335final/Airplane/AirplaneDAO.dart';
import 'package:cst2335final/Airplane/AirplaneItem.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
part 'AirplaneDatabase.g.dart'; // the generated code will be there

/// This is the AirplaneDatabase class.
///
/// This class represents the database for the application. It uses the Floor
/// library to provide an abstraction layer over SQLite. The database contains
/// a single table for AirplaneItem entities.
///
@Database(version: 1, entities: [ AirplaneItem ])
abstract class AirplaneDatabase extends FloorDatabase {

  /// Gets the DAO object to interact with the database.
  ///
  /// This method returns an instance of [AirplaneDAO] which provides methods
  /// to perform CRUD operations on the AirplaneItem table.
  AirplaneDAO get itemDao;
}