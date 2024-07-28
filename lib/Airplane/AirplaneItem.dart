
import 'package:floor/floor.dart';
@entity
class AirplaneItem{

  static int ID = 1; // keep track of IDs

  @primaryKey // id is the primary key of the table
  final int id;

  final String type;

  final int numOfPassenger;

  final double maxSpeed;

  final double flyDistance;


  AirplaneItem(this.id, this.type, this.numOfPassenger, this.maxSpeed, this.flyDistance){ // short version of constructor
    if(id >= ID)
      ID = id + 1;
  }


  bool isValid() {
    // Check for empty string or any other invalid condition for 'type'
    if (type.isEmpty) {
      return false;
    }

    // Check for invalid numOfPassenger value, for example, less than 1
    if (numOfPassenger < 1 ) {
      return false;
    }

    // Check for invalid maxSpeed value, for example, less than or equal to 0
    if (maxSpeed <= 0) {
      return false;
    }

    // Check for invalid flyDistance value, for example, less than or equal to 0
    if (flyDistance <= 0) {
      return false;
    }

    // If all checks passed, return true
    return true;
  }



}
