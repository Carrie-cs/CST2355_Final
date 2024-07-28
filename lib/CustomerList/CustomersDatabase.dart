import 'package:cst2335final/CustomerList/CustomerDAO.dart';
import 'package:cst2335final/CustomerList/Customers.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'CustomersDatabase.g.dart';
/// Represents the database for storing customer information.
@Database(version: 2, entities: [Customers])
abstract class CustomersDatabase extends FloorDatabase{
  CustomerDAO get getDao;
}