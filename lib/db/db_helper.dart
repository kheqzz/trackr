import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackr/db/model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper.init();
  static Database? _database;

  DbHelper.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); //get the default database path
    final path = join(
      dbPath,
      filePath,
    ); //join the default database path with the database name

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tracker_item(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracker_name TEXT NOT NULL,
        type TEXT NOT NULL,
        unit TEXT,
        icon_color TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )''');

    await db.execute('''
      CREATE TABLE tracker(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_tracker_item INTEGER NOT NULL,
        name TEXT NOT NULL,
        note TEXT NOT NULL,
        latestItem INTEGER NOT NULL,
        totalLoggedItem INTEGER NOT NULL,
        entries INTEGER NOT NULL,
        createdAt TEXT NOT NULL,

        FOREIGN KEY (id_tracker_item) REFERENCES tracker_item (id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
        )''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final batch = db.batch();

    batch.insert('tracker_item', {
      'tracker_name': 'clothes',
      'type': 'text',

      'icon_color': '0xff4CAF50',
      'createdAt': DateTime.now().toIso8601String(),
    });
    batch.insert('tracker_item', {
      'tracker_name': 'money',
      'type': 'number',
      'unit': 'IDR',
      'icon_color': '#FF4CAF50',
      'createdAt': DateTime.now().toIso8601String(),
    });
    batch.insert('tracker_item', {
      'tracker_name': 'weight',
      'type': 'number',
      'unit': 'kg',
      'icon_color': '#FF854E4E',
      'createdAt': DateTime.now().toIso8601String(),
    });
    await batch.commit();
  }

  //CRUD
  // Insert
  Future<int> createItem(Item item) async {
    final db = await instance.database;
    return await db.insert('tracker', item.toMap());
  }

  Future<int> createTrackerItem(Map<String, dynamic> trackerItem) async {
    final db = await instance.database;
    return await db.insert('tracker_item', trackerItem);
  }

  // Read
  Future<List<Item>> readAllItems() async {
    final db = await instance.database;
    final result = await db.query('tracker');
    return result.map((e) => Item.fromMap(e)).toList();
  }

  Future<List<TrackerItemPresets>> readAllTrackerItemsPresets() async {
    final db = await instance.database;
    final result = await db.query('tracker_item');
    return result.map((e) => TrackerItemPresets.fromMap(e)).toList();
  }

  // Update
  Future<int> updateItem(Item item) async {
    final db = await instance.database;
    return await db.update(
      'tracker',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> updateItemCount(
    int id,
    int latestItem,
    int totalLoggedItem,
    int entries,
  ) async {
    final db = await instance.database;
    return await db.rawUpdate(
      'UPDATE tracker SET latestItem = ?, totalLoggedItem = ?, entries = ? WHERE id = ?',
      [latestItem, totalLoggedItem, entries, id],
    );
  }

  // Delete
  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete('tracker', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTrackerItemPresets(int id) async {
    final db = await instance.database;
    return await db.delete('tracker_item', where: 'id = ?', whereArgs: [id]);
  }
}
