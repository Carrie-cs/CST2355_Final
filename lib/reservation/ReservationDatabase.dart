import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:cst2335final/reservation/ReservationDao.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'ReservationDatabase.g.dart';
/// The [ReservationDatabase] class represents the Room database for managing [Reservation] entities.
///
/// This abstract class defines the database schema and provides access to [ReservationDao],
/// which contains methods to interact with [Reservation] entities in the database.
///
/// @author: Hongxiu Guo
@Database(version: 1, entities: [Reservation])
abstract class ReservationDatabase  extends FloorDatabase{
  /// Provides access to the [ReservationDao] for performing CRUD operations on [Reservation] entities.
  ///
  /// Use this getter to obtain an instance of [ReservationDao], which allows you to query,
  /// insert, update, and delete reservation.
  ReservationDao get reservationDao;

}