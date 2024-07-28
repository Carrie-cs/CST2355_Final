
import 'package:floor/floor.dart';

/// Represents an Reservation entity.
///
/// This class is used to define the structure of an Reservation record in the database.
/// It contains information about the Reservation's ID, customerId, flightId, and date of departure
///
/// @author: Hongxiu Guo
@entity
class Reservation{
  /// A static variable to keep track of the latest ID.
  static int ID = 1;

  /// The primary key of the reservation table.
  @primaryKey // id is the primary key of the table
  final int id;

  /// The ID of the customer from customer database
  final int customerId;

  /// The ID of the flight from flight database
  final String flightId;

  /// The departure date of the flight.
  final String departureTime;

  /// Constructor for creating a `Reservation` object.
  ///
  /// Takes in an ID, customer ID, flight ID, and departure time.
  /// Updates the static `ID` variable to ensure unique IDs.
  Reservation(this.id, this.customerId, this.flightId, this.departureTime){
    if(id >= ID) ID = id + 1;
  }
}