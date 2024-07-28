
// floor will generate the functions for us, so we mark this class as abstract

import 'package:floor/floor.dart';
import 'package:cst2335final/Airplane/AirplaneItem.dart';


@dao // this is a DAO class
abstract class AirplaneDAO {

  //insert:
  @insert
  Future<void> insertAirplane(AirplaneItem item);

  //delete:
  @delete // translated delete from AirplaneItem where (id = ...)
  Future<int> deleteAirplane(AirplaneItem item);

  //Query:
  @Query('SELECT * FROM AirplaneItem')
  Future< List<AirplaneItem> > getAllItems();

  //Query:
  @Query('SELECT * FROM AirplaneItem where id = :id')
  Future< List<AirplaneItem> > getItems(int id);

  // update:
  @update // translated to update AirplaneItem where id = ...
  Future<int> updateAirplane(AirplaneItem item);



}