import 'package:floor/floor.dart';

/// Represents a flight entity.
///
/// This class is used to define the structure of a flight record in the database.
/// It contains information about the flight's ID, departure city, destination city,
/// departure time, and arrival time.
///
/// @author: Yao Yi
@entity
class Flight {

  /// The unique identifier for the flight.
  @primaryKey
  String flightId;

  /// The city from which the flight departs.
  String departureCity;

  /// The city to which the flight is arriving.
  String destinationCity;

  /// The time at which the flight departs.
  String departureTime;

  /// The time at which the flight arrives.
  String arrivalTime;

  /// Creates a new [Flight] instance with the given details.
  ///
  /// [flightId] is the unique identifier for the flight.
  /// [departureCity] is the city from which the flight departs.
  /// [destinationCity] is the city to which the flight is arriving.
  /// [departureTime] is the time at which the flight departs.
  /// [arrivalTime] is the time at which the flight arrives.
  Flight(
      this.flightId,
      this.departureCity,
      this.destinationCity,
      this.departureTime,
      this.arrivalTime,
      );
}