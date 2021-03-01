import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbRepository {
  Future<Database> _getDatabase() async {
    //deleteDatabase(DATABASE);
    return openDatabase(join(await getDatabasesPath(), DATABASE),
        onCreate: (db, version) async {
      await db.execute(CREATE_CREDIT_CARD_TABLE);
      await db.execute(CREATE_OWNER_TABLE);
      await db.execute(CREATE_DEBIT_TABLE);
      await db.execute(CREATE_OWNER_DEBIT_TABLE);
    }, version: 1);
  }

  Future<int> insert(Map entry, String table) async {
    try {
      final Database db = await _getDatabase();
      return await db.insert(table, entry);
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> delete(dynamic entry) async {
    try {
      final Database db = await _getDatabase();
      await db.delete(keyCreditCardTable,
          where: "$keyIdCreditCard = ?", whereArgs: [entry.id]);
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<dynamic>> getEntries(String table, {int whereArgs}) async {
    try {
      final Database db = await _getDatabase();
      List<Map<String, dynamic>> list;

      switch (table) {
        case keyCreditCardTable:
          list = await db.query(table);
          return List.generate(
              list.length, (index) => CreditCard().fromMap(list[index]));
          break;
        case keyOwnerTable:
          list = await db.query(table);
          return List.generate(
              list.length, (index) => Owner().fromMap(list[index]));
          break;
        case keyDebitTable:
          //list = await db.query(keyOwnerDebitTable);
          //list = await db.rawQuery(SELECT_DEBITS);
          list = await db.query(table,
              where: "$keyCreditCardIdDebit = ?", whereArgs: [whereArgs]);
          return List.generate(
              list.length, (index) => Debit().fromMap(list[index]));
          break;
      }
    } catch (ex) {
      print(ex);
      return new List<Map<String, dynamic>>();
    }
  }

  Future<List<Debit>> getDebitsEntries() async {
    List<Debit> debitsList = [];

    int count = 1;

    try {
      final Database db = await _getDatabase();

      List<Map<String, dynamic>> list;

      list = await db.rawQuery(SELECT_DEBITS);

      list.forEach((debit) {
        if (debit["debit_id"] == list[count]["debit_id"] && list.length < count) {
          Debit d = Debit().fromMap(debit);
          d.ownerId.add(list[count + 1]["owner_id"]);
          d.ownerId.add(debit["owner_id"]);
          debitsList.add(d);
        }else{
          Debit d = Debit().fromMap(debit);
          d.ownerId.add(debit["owner_id"]);
          debitsList.add(d);
        }
        count++;
      });
    } catch (ex) {
      print(ex);
    }
    return debitsList;
  }
}
