import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:floor/floor.dart';
/// Data Access Object (DAO) for performing CRUD operations on [Reservation] entities.
///
/// This DAO provides methods to query, insert, update, and delete Reservation in the database.
///
/// @author: Hongxiu Guo
@dao
abstract class ReservationDao{
    /// Query to get all reservations from the Reservation table
    @Query('SELECT * FROM Reservation')
    Future<List<Reservation>> getAllReservations();

    /// Query to get a single reservation by its ID
    ///
    /// Takes in an [id] and returns a [Future] of [Reservation?] (nullable Reservation).
    @Query("Select * from Reservation where id = :id")
    Future<Reservation?> getById(int id);

    /// Insert a new reservation into the Reservation table
    ///
    /// Takes in a [Reservation] object and inserts it into the database.
    @insert
    Future<void> insertReservation(Reservation item);

    /// Delete a reservation from the Reservation table
    ///
    /// Takes in a [Reservation] object and deletes it from the database.
    /// Returns the number of rows affected.
    @delete //translate delete from Reservation where id = ... the primary key
    Future<int> deleteReservation(Reservation item);

    /// Update an existing reservation in the Reservation table
    ///
    /// Takes in an updated [Reservation] object with the same id and updates the corresponding row in the database.
    /// Returns the number of rows affected.
    @update // translate to update message in Reservation where id = ...
    Future<int> updateReservation(Reservation item);// pass in an updated item with the same id


}