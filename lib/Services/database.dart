import 'package:manek_demo/utils/import_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "Products.db";
  static final _databaseVersion = 1;

//Product list table
  static final table = 'products_list';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnPrice = 'price';
  static final columnImage = 'featured_image';
  static final columnStatus = 'status';

  //
  static final table2 = 'cartData';

  static final cartIDCol = 'id';
  static final cartQtyCol = 'quantity';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    // print(_database);
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnPrice INTEGER NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnStatus TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table2 (
            $cartIDCol INTEGER PRIMARY KEY,
            $cartQtyCol INTEGER NOT NULL,
             FOREIGN KEY($cartIDCol) REFERENCES $table($columnId)
          )
          ''');
  }

  // Helper methods

//Product list table
//Returns total rows in the product table
  Future<int> getProductCount() async {
    Database db = await this.database;
    var x = await db.rawQuery('SELECT COUNT (*) from $table');
    int count = Sqflite.firstIntValue(x) ?? 0;
    return count;
  }

//insert a product record
  Future<int> insertProduct(Product row) async {
    Database db = await instance.database;
    return await db.insert(table, row.toJson());
  }

  // Future<List<Product>> queryAllProducts() async {
  //   Database db = await instance.database;
  //   final res = await db.query(table);
  //   List<Product> list =
  //       res.isNotEmpty ? res.map((c) => Product.fromJson(c)).toList() : [];
  //   return list;
  // }

  //Returns limited rows
  Future<List<Product>> queryLimitProducts(offset, limit) async {
    Database db = await instance.database;
    final res = await db.query(table, limit: limit, offset: offset);
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromJson(c)).toList() : [];
    return list;
  }

//cart table
  Future<int> getCartCount() async {
    Database db = await this.database;
    var x = await db.rawQuery('SELECT COUNT (*) from $table2');
    int count = Sqflite.firstIntValue(x) ?? 0;
    return count;
  }

//check a row exists in cart table
  Future<int> isExistsIncart(id) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $table2 WHERE $cartIDCol=$id)',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

//insert a cart item
  Future<int> insertCartItem(Cart row) async {
    Database db = await instance.database;
    return await db.insert(table2, row.toJson());
  }

//update a cart item
  Future<int> updateCartItem(int id) async {
    try {
      Database db = await instance.database;
      final res = await db.query(table2,
          columns: [cartQtyCol], where: '$cartIDCol = ?', whereArgs: [id]);
      List<Cart> list =
          res.isNotEmpty ? res.map((c) => Cart.fromJson(c)).toList() : [];
      int actualQuantity = list[0].quantity!;
      Map<String, dynamic> row = {
        cartQtyCol: actualQuantity + 1,
      };
      return await db
          .update(table2, row, where: '$cartIDCol = ?', whereArgs: [id]);
    } catch (e) {
      return 0;
    }
  }

//fetch total units of items in the table
  Future<Map> getTotalCartItems() async {
    Database db = await instance.database;
    final result = await db
        .rawQuery('SELECT sum($cartQtyCol) as totalQuantity FROM $table2');
    var res = result.toList()[0];
    return res;
  }

  //delete item from cart table
   Future<int> deleteCartItem(itemId) async {
    Database db = await instance.database;
    final result = await db
         .delete(table2, where: '$cartIDCol = ?', whereArgs: [itemId]);
    return result;
  }

  //Both tables
  Future<List<CartItem>> getCartItemList() async {
    Database db = await instance.database;
    final result = await db.rawQuery(
        'SELECT $table.$columnId, $table.$columnTitle, $table.$columnDescription, $table.$columnPrice,'
        '$table.$columnImage, $table2.$cartQtyCol from $table INNER JOIN $table2 ON $table.$columnId = $table2.$cartIDCol');
    // .rawQuery('SELECT * from $table RIGHT JOIN $table2 ON $table.id = $table2.id');
    var res = result.toList();
    List<CartItem> list =
        res.isNotEmpty ? res.map((c) => CartItem.fromJson(c)).toList() : [];
    return list;
  }

//common to all tables
//Deletes all the rows in the table
  Future<int> delete(tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName);
  }

//Drops the table
  Future<dynamic> deleteTable(tableName) async {
    Database db = await instance.database;
    return await db.rawQuery('DROP TABLE IF EXISTS $tableName');
  }
}
