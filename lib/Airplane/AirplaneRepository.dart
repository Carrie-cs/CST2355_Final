
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class AirplaneRepository{

  //initialize the EncryptedSharedPreferences object
  static EncryptedSharedPreferences storedDataEncrypted = EncryptedSharedPreferences();


  // responsible for loading and saving its variables
  // list variables for every page to access

  static String type = "";
  static String numOfPassenger = "";
  static String maxSpeed = "";
  static String flyDistance = "";




  static Future<void> saveData() async {
    // put in EncryptedSharedPreferences.
    await storedDataEncrypted.setString("type", type) ;
    await storedDataEncrypted.setString("numOfPassenger", numOfPassenger) ;
    await storedDataEncrypted.setString("maxSpeed", maxSpeed) ;
    await storedDataEncrypted.setString("flyDistance", flyDistance) ;
  }


  static Future<void> loadData() async {
    // Load from EncryptedSharedPreferences.
    type = await storedDataEncrypted.getString("type") ?? "";
    numOfPassenger = await storedDataEncrypted.getString("numOfPassenger") ?? "";
    maxSpeed = await storedDataEncrypted.getString("maxSpeed") ?? "";
    flyDistance = await storedDataEncrypted.getString("flyDistance") ?? "";

  }


}