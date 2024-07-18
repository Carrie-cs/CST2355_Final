import 'package:floor/floor.dart';

import 'flight.dart';


@dao
abstract class FlightDao {
  @Query('SELECT * FROM Flight')
  Future<List<Flight>> getAllFlight();

  @Query('SELECT * FROM Flight WHERE flightId = :flightId')
  Stream<Flight?> getFlightById(String flightId);

  @insert
  Future<void> addFlight(Flight flight);

  @update
  Future<int> updateFlight(Flight flight);

  @delete
  Future<int> deleteFlight(Flight flight);
}