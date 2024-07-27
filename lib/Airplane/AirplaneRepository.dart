




import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// This is the AirplaneRepository class.
///
/// This class is responsible for managing the storage and retrieval of airplane-related
/// data using EncryptedSharedPreferences. It provides methods to save and load data
/// securely.
class AirplaneRepository{

  /// Initializes the EncryptedSharedPreferences object.
  ///
  /// This object is used to store and retrieve encrypted data.
  static EncryptedSharedPreferences storedDataEncrypted = EncryptedSharedPreferences();

  /// Variables to store airplane data.
  ///
  /// These variables are accessible from every page and are used to store
  /// the type, number of passengers, max speed, and fly distance of the airplane.
  static String type = "";
  static String numOfPassenger = "";
  static String maxSpeed = "";
  static String flyDistance = "";



  /// Saves the airplane data to EncryptedSharedPreferences.
  ///
  /// This method stores the current values of the type, numOfPassenger, maxSpeed,
  /// and flyDistance variables in encrypted shared preferences.
  static Future<void> saveData() async {
    await storedDataEncrypted.setString("type", type) ;
    await storedDataEncrypted.setString("numOfPassenger", numOfPassenger) ;
    await storedDataEncrypted.setString("maxSpeed", maxSpeed) ;
    await storedDataEncrypted.setString("flyDistance", flyDistance) ;
  }

  /// Loads the airplane data from EncryptedSharedPreferences.
  ///
  /// This method retrieves the values of the type, numOfPassenger, maxSpeed,
  /// and flyDistance variables from encrypted shared preferences and assigns
  /// them to the corresponding static variables.
  static Future<void> loadData() async {
    type = await storedDataEncrypted.getString("type") ?? "";
    numOfPassenger = await storedDataEncrypted.getString("numOfPassenger") ?? "";
    maxSpeed = await storedDataEncrypted.getString("maxSpeed") ?? "";
    flyDistance = await storedDataEncrypted.getString("flyDistance") ?? "";

  }


}
