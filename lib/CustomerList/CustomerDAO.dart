import 'package:cst2335final/CustomerList/Customers.dart';
import 'package:floor/floor.dart';

@dao
abstract class CustomerDAO{
  @insert
  Future<void> insertCustomer(Customers customer);

  @delete
  Future<int> deleteCustomer(Customers customer);

  @Query('SELECT * FROM Customers')
  Future<List<Customers>> getAllCustomers();

  @Query('SELECT * FROM Customers WEHERE customerId = :customerId')
  Future<List<Customers>> getCustomer(int customerId);

  @update
  Future<int> updateCustomer(Customers customer);

}