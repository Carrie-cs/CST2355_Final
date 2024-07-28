// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'AirplaneDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AirplaneDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AirplaneDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AirplaneDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AirplaneDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAirplaneDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AirplaneDatabaseBuilderContract databaseBuilder(String name) =>
      _$AirplaneDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AirplaneDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AirplaneDatabaseBuilder(null);
}

class _$AirplaneDatabaseBuilder implements $AirplaneDatabaseBuilderContract {
  _$AirplaneDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AirplaneDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AirplaneDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AirplaneDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AirplaneDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AirplaneDatabase extends AirplaneDatabase {
  _$AirplaneDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AirplaneDAO? _itemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `AirplaneItem` (`id` INTEGER NOT NULL, `type` TEXT NOT NULL, `numOfPassenger` INTEGER NOT NULL, `maxSpeed` REAL NOT NULL, `flyDistance` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AirplaneDAO get itemDao {
    return _itemDaoInstance ??= _$AirplaneDAO(database, changeListener);
  }
}

class _$AirplaneDAO extends AirplaneDAO {
  _$AirplaneDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _airplaneItemInsertionAdapter = InsertionAdapter(
            database,
            'AirplaneItem',
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numOfPassenger': item.numOfPassenger,
                  'maxSpeed': item.maxSpeed,
                  'flyDistance': item.flyDistance
                }),
        _airplaneItemUpdateAdapter = UpdateAdapter(
            database,
            'AirplaneItem',
            ['id'],
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numOfPassenger': item.numOfPassenger,
                  'maxSpeed': item.maxSpeed,
                  'flyDistance': item.flyDistance
                }),
        _airplaneItemDeletionAdapter = DeletionAdapter(
            database,
            'AirplaneItem',
            ['id'],
            (AirplaneItem item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numOfPassenger': item.numOfPassenger,
                  'maxSpeed': item.maxSpeed,
                  'flyDistance': item.flyDistance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirplaneItem> _airplaneItemInsertionAdapter;

  final UpdateAdapter<AirplaneItem> _airplaneItemUpdateAdapter;

  final DeletionAdapter<AirplaneItem> _airplaneItemDeletionAdapter;

  @override
  Future<List<AirplaneItem>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM AirplaneItem',
        mapper: (Map<String, Object?> row) => AirplaneItem(
            row['id'] as int,
            row['type'] as String,
            row['numOfPassenger'] as int,
            row['maxSpeed'] as double,
            row['flyDistance'] as double));
  }

  @override
  Future<List<AirplaneItem>> getItems(int id) async {
    return _queryAdapter.queryList('SELECT * FROM AirplaneItem where id = ?1',
        mapper: (Map<String, Object?> row) => AirplaneItem(
            row['id'] as int,
            row['type'] as String,
            row['numOfPassenger'] as int,
            row['maxSpeed'] as double,
            row['flyDistance'] as double),
        arguments: [id]);
  }

  @override
  Future<void> insertAirplane(AirplaneItem item) async {
    await _airplaneItemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateAirplane(AirplaneItem item) {
    return _airplaneItemUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteAirplane(AirplaneItem item) {
    return _airplaneItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
