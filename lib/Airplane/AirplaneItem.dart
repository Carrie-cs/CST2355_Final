


import 'package:floor/floor.dart';


/// Represents an Airline entity.
///
/// This class is used to define the structure of an Airline record in the database.
/// It contains information about the Airline's ID, Airline type, number of passenger,
/// max speed, and fly distance.
///
/// @author: WANG JIAYUN


@entity
class AirplaneItem{

  /// The unique identifier to keep track of IDs for the airplane.
  static int ID = 1;

  /// The unique identifier of the airplane.
  @primaryKey
  final int id;

  /// The type of the airplane.
  final String type;

  /// The number of passenger of the airplane.
  final int numOfPassenger;

  /// The max speed of the airplane.
  final double maxSpeed;

  /// The fly distance of the airplane.
  final double flyDistance;


  /// Creates a new [AirplaneItem] instance with the given details.
  ///
  /// [id] is the unique identifier of the airplane.
  /// [type] is type of the airplane.
  /// [numOfPassenger] is the number of passenger of the airplane.
  /// [maxSpeed] is the max speed of the airplane.
  /// [flyDistance] is the  fly distance of the airplane.
  AirplaneItem(this.id, this.type, this.numOfPassenger, this.maxSpeed, this.flyDistance){
    if(id >= ID)
      ID = id + 1;
  }


}
