import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
///A repository class for managing repository data using encrypted shared preferences.
class ReservationRepository{
  // static String flightId = "";
  // static int customerId = -1;
  static String date = "";

  static EncryptedSharedPreferences encrypted = EncryptedSharedPreferences();

  ///Loads data from encrypted shared preferences.
  static Future<void> loadData() async{
    // flightId = await encrypted.getString("flightId");
    // customerId = (await encrypted.getString("customerId")) as int;
    date = await encrypted.getString("date");
  }

  ///Saves data to encrypted shared preferences.
  static saveData(){
    var prefs = EncryptedSharedPreferences();
    // prefs.setString("flightId", flightId);
    // prefs.setString("customerId", customerId);
    prefs.setString("date", date);
  }

  ///Clears data from encrypted shared preferences.
  static clearData(){
    var prefs = EncryptedSharedPreferences();
    // prefs.remove("flightId");
    // prefs.remove("customerId");
    prefs.remove("date");
  }
}