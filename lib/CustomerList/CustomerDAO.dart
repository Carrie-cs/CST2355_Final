import 'package:cst2335final/CustomerList/Customers.dart';
import 'package:floor/floor.dart';

@dao
/// Data Access Object (DAO) for interacting with the Customers table in the database.
abstract class CustomerDAO{
  /// Inserts a new customer into the Customers table.
  @insert
  Future<void> insertCustomer(Customers customer);

  /// Deletes a customer from the Customers table.
  @delete
  Future<int> deleteCustomer(Customers customer);

  /// Retrieves all customers from the Customers table.
  @Query('SELECT * FROM Customers')
  Future<List<Customers>> getAllCustomers();

  /// Retrieves a customer from the Customers table by customer ID.
  @Query('SELECT * FROM Customers WHERE customerId = :customerId')
  Future<List<Customers>> getCustomer(int customerId);

  /// Updates an existing customer in the Customers table.
  @update
  Future<int> updateCustomer(Customers customer);

}