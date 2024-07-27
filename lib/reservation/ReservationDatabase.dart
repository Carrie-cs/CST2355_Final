import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:cst2335final/reservation/ReservationDao.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'ReservationDatabase.g.dart';

@Database(version: 1, entities: [Reservation])
abstract class ReservationDatabase  extends FloorDatabase{
  ReservationDao get reservationDao;

}