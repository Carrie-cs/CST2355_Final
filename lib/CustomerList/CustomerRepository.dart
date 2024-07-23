import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomerRepository{
  static String firstName = "";
  static String lastName ="";
  static String address = "";
  static String birthday = "";
  static EncryptedSharedPreferences encrypted = EncryptedSharedPreferences();

  static Future<void> loadData() async{
    firstName = await encrypted.getString("firstName");
    lastName = await encrypted.getString("lastName");
    address = await encrypted.getString("address");
    birthday = await encrypted.getString("birthday");
  }

  static saveData(){
    var prefs = EncryptedSharedPreferences();
    prefs.setString("firstName", firstName);
    prefs.setString("lastName", lastName);
    prefs.setString("address", address);
    prefs.setString("birthday", birthday);
  }
}