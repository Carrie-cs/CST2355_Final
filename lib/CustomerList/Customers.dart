import 'package:floor/floor.dart';

/// Represents a customer entity for the database.
@entity
class Customers{
  static int ID = 1;
  /// The unique identifier for the customer.
  @primaryKey
  final int customerId;
  /// The first name of the customer.
  final String firstName;
  /// The last name of the customer.
  final String lastName;
  /// The address of the customer.
  final String address;
  /// The address of the customer.
  final String birthday;

  ///Constructs a new `Customers` instance.
  Customers(this.customerId,this.firstName,this.lastName,this.address,this.birthday){
    if(customerId>= ID){
      ID = customerId +1;
    }
  }

  ///Checks if the customer's data is not null.
  bool isValid(){
    if (firstName.isEmpty ){
      return false;
    }

    if(lastName.isEmpty){
      return false;
    }
    if(address.isEmpty){
      return false;
    }

    if(birthday.isEmpty){
      return false;
    }

    return true;
  }

}



