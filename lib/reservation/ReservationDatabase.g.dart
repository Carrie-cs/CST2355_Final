// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReservationDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ReservationDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ReservationDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ReservationDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ReservationDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorReservationDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ReservationDatabaseBuilderContract databaseBuilder(String name) =>
      _$ReservationDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ReservationDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ReservationDatabaseBuilder(null);
}

class _$ReservationDatabaseBuilder
    implements $ReservationDatabaseBuilderContract {
  _$ReservationDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ReservationDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ReservationDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ReservationDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ReservationDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ReservationDatabase extends ReservationDatabase {
  _$ReservationDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ReservationDao? _reservationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
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
            'CREATE TABLE IF NOT EXISTS `Reservation` (`id` INTEGER NOT NULL, `customerId` INTEGER NOT NULL, `flightId` TEXT NOT NULL, `departureTime` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ReservationDao get reservationDao {
    return _reservationDaoInstance ??=
        _$ReservationDao(database, changeListener);
  }
}

class _$ReservationDao extends ReservationDao {
  _$ReservationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reservationInsertionAdapter = InsertionAdapter(
            database,
            'Reservation',
            (Reservation item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'departureTime': item.departureTime
                }),
        _reservationUpdateAdapter = UpdateAdapter(
            database,
            'Reservation',
            ['id'],
            (Reservation item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'departureTime': item.departureTime
                }),
        _reservationDeletionAdapter = DeletionAdapter(
            database,
            'Reservation',
            ['id'],
            (Reservation item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'departureTime': item.departureTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reservation> _reservationInsertionAdapter;

  final UpdateAdapter<Reservation> _reservationUpdateAdapter;

  final DeletionAdapter<Reservation> _reservationDeletionAdapter;

  @override
  Future<List<Reservation>> getAllReservations() async {
    return _queryAdapter.queryList('SELECT * FROM Reservation',
        mapper: (Map<String, Object?> row) => Reservation(
            row['id'] as int,
            row['customerId'] as int,
            row['flightId'] as String,
            row['departureTime'] as String));
  }

  @override
  Future<Reservation?> getById(int id) async {
    return _queryAdapter.query('Select * from Reservation where id = ?1',
        mapper: (Map<String, Object?> row) => Reservation(
            row['id'] as int,
            row['customerId'] as int,
            row['flightId'] as String,
            row['departureTime'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertReservation(Reservation item) async {
    await _reservationInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateReservation(Reservation item) {
    return _reservationUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteReservation(Reservation item) {
    return _reservationDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
