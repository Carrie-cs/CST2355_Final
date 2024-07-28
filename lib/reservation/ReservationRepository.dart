import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
/// This is the ReservationRepository class.
///
/// This class is responsible for managing the storage and retrieval of reservation-related
/// data using EncryptedSharedPreferences. It provides methods to save and load data securely.
///
/// @author: Hongxiu Guo
class ReservationRepository{
  // static String flightId = "";
  // static int customerId = -1;
  /// Static variable to store the date.
  static String date = "";
  /// Instance of EncryptedSharedPreferences for secure storage.
  static EncryptedSharedPreferences encrypted = EncryptedSharedPreferences();

  /// Loads data from encrypted shared preferences.
  ///
  /// Retrieves the stored date and assigns it to the static `date` variable.
  static Future<void> loadData() async{
    // flightId = await encrypted.getString("flightId");
    // customerId = (await encrypted.getString("customerId")) as int;
    date = await encrypted.getString("date");
  }

  /// Saves data to encrypted shared preferences.
  ///
  /// Stores the current value of the static `date` variable.
  static saveData(){
    var prefs = EncryptedSharedPreferences();
    // prefs.setString("flightId", flightId);
    // prefs.setString("customerId", customerId);
    prefs.setString("date", date);
  }

  /// Clears data from encrypted shared preferences.
  ///
  /// Removes the stored date from the preferences.
  static clearData(){
    var prefs = EncryptedSharedPreferences();
    // prefs.remove("flightId");
    // prefs.remove("customerId");
    prefs.remove("date");
  }
}