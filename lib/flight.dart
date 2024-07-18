import 'package:floor/floor.dart';

@entity
class Flight {

  @primaryKey
  final String flightId;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;

  Flight(this.flightId,
         this.departureCity,
         this.destinationCity,
         this.departureTime,
         this.arrivalTime);

}