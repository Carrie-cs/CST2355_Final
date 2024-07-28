
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
///A repository class for managing customer data using encrypted shared preferences.
class CustomerRepository{
  static String firstName = "";
  static String lastName ="";
  static String address = "";
  static String birthday = "";
  static EncryptedSharedPreferences encrypted = EncryptedSharedPreferences();

  ///Loads customer data from encrypted shared preferences.
  static Future<void> loadData() async{
    firstName = await encrypted.getString("firstName");
    lastName = await encrypted.getString("lastName");
    address = await encrypted.getString("address");
    birthday = await encrypted.getString("birthday");
  }

  ///Saves customer data to encrypted shared preferences.
  static saveData(){
    var prefs = EncryptedSharedPreferences();
    prefs.setString("firstName", firstName);
    prefs.setString("lastName", lastName);
    prefs.setString("address", address);
    prefs.setString("birthday", birthday);
  }

  ///Clears customer data from encrypted shared preferences.
  static clearData(){
    var prefs = EncryptedSharedPreferences();
    prefs.remove("firstName");
    prefs.remove("lastName");
    prefs.remove("address");
    prefs.remove("birthday");
  }
}