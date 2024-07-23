import 'package:floor/floor.dart';

@entity
class Customers{
  static int ID = 1;
  @primaryKey
  final int customerId;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customers(this.customerId,this.firstName,this.lastName,this.address,this.birthday){
    if(customerId>= ID){
      ID = customerId +1;
    }
  }

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



