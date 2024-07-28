import 'package:floor/floor.dart';

import 'flight.dart';
/// Data Access Object (DAO) for performing CRUD operations on [Flight] entities.
///
/// This DAO provides methods to query, insert, update, and delete flights in the database.
/// @author: Yao Yi
@dao
abstract class FlightDao {
  /// Retrieves all flights from the database.
  ///
  /// Returns a [Future] that completes with a list of [Flight] objects.
  @Query('SELECT * FROM Flight')
  Future<List<Flight>> getAllFlight();

  /// Retrieves a flight by its unique identifier.
  ///
  /// Returns a [Stream] that emits the [Flight] object with the specified [flightId].
  /// The stream will emit `null` if no flight is found with the given ID.
  @Query('SELECT * FROM Flight WHERE flightId = :flightId')
  Stream<Flight?> getFlightById(String flightId);

  /// Inserts a new flight into the database.
  ///
  /// The [flight] parameter represents the flight to be added.
  /// This method completes when the flight has been successfully inserted.
  @insert
  Future<void> addFlight(Flight flight);

  /// Updates an existing flight in the database.
  ///
  /// The [flight] parameter represents the flight to be updated.
  /// Returns the number of rows affected by the update operation.
  @update
  Future<int> updateFlight(Flight flight);

  /// Deletes a flight from the database.
  ///
  /// The [flight] parameter represents the flight to be deleted.
  /// Returns the number of rows affected by the delete operation.
  @delete
  Future<int> deleteFlight(Flight flight);
}