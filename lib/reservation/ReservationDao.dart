import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReservationDao{

    @Query('SELECT * FROM Reservation')
    Future<List<Reservation>> getAllReservations();

    //query one
    @Query("Select * from Reservation where id = :id")
    Future<Reservation?> getById(int id);

    //insert
    @insert
    Future<void> insertReservation(Reservation item);

    //delete
    @delete //translate delete from Reservation where id = ... the primary key
    Future<int> deleteReservation(Reservation item);

    //update
    @update // translate to update message in Reservation where id = ...
    Future<int> updateReservation(Reservation item);// pass in an updated item with the same id


}