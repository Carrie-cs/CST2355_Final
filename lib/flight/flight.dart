import 'package:floor/floor.dart';

@entity
class Flight {

  @primaryKey
  String flightId;
  String departureCity;
  String destinationCity;
  String departureTime;
  String arrivalTime;

  Flight(this.flightId,
         this.departureCity,
         this.destinationCity,
         this.departureTime,
         this.arrivalTime);

}