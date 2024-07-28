



import 'package:floor/floor.dart';
import 'package:cst2335final/Airplane/AirplaneItem.dart';

/// This is AirplaneDAO class.
///
/// This class provides the Data Access Object (DAO) for the AirplaneItem entity.
/// It contains methods to perform CRUD (Create, Read, Update, Delete) operations
/// on the AirplaneItem table in the database.
@dao
abstract class AirplaneDAO {


  /// Inserts a new [AirplaneItem] into the database.
  ///
  /// [item] is the AirplaneItem to be inserted.
  /// This method returns a [Future] that completes when the insertion is done.
  @insert
  Future<void> insertAirplane(AirplaneItem item);

  /// Deletes an existing [AirplaneItem] from the database.
  ///
  /// [item] is the AirplaneItem to be deleted.
  /// This method returns a [Future] that completes with the number of rows affected.
  @delete
  Future<int> deleteAirplane(AirplaneItem item);

  /// Retrieves all [AirplaneItem] records from the database.
  ///
  /// This method returns a [Future] that completes with a list of all AirplaneItem records.
  @Query('SELECT * FROM AirplaneItem')
  Future< List<AirplaneItem> > getAllItems();

  /// Retrieves [AirplaneItem] records with the specified ID from the database.
  ///
  /// [id] is the unique identifier of the AirplaneItem to be retrieved.
  /// This method returns a [Future] that completes with a list of AirplaneItem records matching the ID.
  @Query('SELECT * FROM AirplaneItem where id = :id')
  Future< List<AirplaneItem> > getItems(int id);

  /// Updates an existing [AirplaneItem] in the database.
  ///
  /// [item] is the AirplaneItem to be updated.
  /// This method returns a [Future] that completes with the number of rows affected.
  @update
  Future<int> updateAirplane(AirplaneItem item);



}
