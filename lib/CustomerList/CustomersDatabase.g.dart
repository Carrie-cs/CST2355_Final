// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomersDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $CustomersDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $CustomersDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $CustomersDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<CustomersDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorCustomersDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomersDatabaseBuilderContract databaseBuilder(String name) =>
      _$CustomersDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CustomersDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$CustomersDatabaseBuilder(null);
}

class _$CustomersDatabaseBuilder implements $CustomersDatabaseBuilderContract {
  _$CustomersDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $CustomersDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $CustomersDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<CustomersDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CustomersDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CustomersDatabase extends CustomersDatabase {
  _$CustomersDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CustomerDAO? _getDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Customers` (`customerId` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `birthday` TEXT NOT NULL, PRIMARY KEY (`customerId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CustomerDAO get getDao {
    return _getDaoInstance ??= _$CustomerDAO(database, changeListener);
  }
}

class _$CustomerDAO extends CustomerDAO {
  _$CustomerDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customersInsertionAdapter = InsertionAdapter(
            database,
            'Customers',
            (Customers item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customersUpdateAdapter = UpdateAdapter(
            database,
            'Customers',
            ['customerId'],
            (Customers item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customersDeletionAdapter = DeletionAdapter(
            database,
            'Customers',
            ['customerId'],
            (Customers item) => <String, Object?>{
                  'customerId': item.customerId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Customers> _customersInsertionAdapter;

  final UpdateAdapter<Customers> _customersUpdateAdapter;

  final DeletionAdapter<Customers> _customersDeletionAdapter;

  @override
  Future<List<Customers>> getAllCustomers() async {
    return _queryAdapter.queryList('SELECT * FROM Customers',
        mapper: (Map<String, Object?> row) => Customers(
            row['customerId'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['birthday'] as String));
  }

  @override
  Future<List<Customers>> getCustomer(int customerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Customers WHERE customerId = ?1',
        mapper: (Map<String, Object?> row) => Customers(
            row['customerId'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['birthday'] as String),
        arguments: [customerId]);
  }

  @override
  Future<void> insertCustomer(Customers customer) async {
    await _customersInsertionAdapter.insert(customer, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCustomer(Customers customer) {
    return _customersUpdateAdapter.updateAndReturnChangedRows(
        customer, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCustomer(Customers customer) {
    return _customersDeletionAdapter.deleteAndReturnChangedRows(customer);
  }
}
