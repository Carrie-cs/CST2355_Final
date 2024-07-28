
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:cst2335final/Airplane/AirplaneDAO.dart';
import 'package:cst2335final/Airplane/AirplaneItem.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
part 'AirplaneDatabase.g.dart'; // the generated code will be there
// when you modify the table structure, you can change the version to 2,3,...,
// the old version table is dropped and recreated a new table
@Database(version: 1, entities: [ AirplaneItem ])
abstract class AirplaneDatabase extends FloorDatabase {

  // get the DAO object to interact with the database
  AirplaneDAO get itemDao;
}