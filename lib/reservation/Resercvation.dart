
import 'package:floor/floor.dart';

@entity
class Reservation{

  static int ID = 1;

  @primaryKey // id is the primary key of the table
  final int id;

  final int customerId;

  final String flightId;

  final String departureTime;

  Reservation(this.id, this.customerId, this.flightId, this.departureTime){
    if(id >= ID) ID = id + 1;
  }
}