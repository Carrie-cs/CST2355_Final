import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'flight.dart';
import 'flight_dao.dart';

part 'flight_database.g.dart';

/// The [FlightDatabase] class represents the Room database for managing [Flight] entities.
///
/// This abstract class defines the database schema and provides access to [FlightDao],
/// which contains methods to interact with [Flight] entities in the database.
///
/// @author: Yao Yi
@Database(version: 1, entities: [Flight])
abstract class FlightDatabase extends FloorDatabase {
  /// Provides access to the [FlightDao] for performing CRUD operations on [Flight] entities.
  ///
  /// Use this getter to obtain an instance of [FlightDao], which allows you to query,
  /// insert, update, and delete flights.
  FlightDao get flightDao;
}