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

  Future<void> delete({String table, dynamic entry}) async {
    final Database db = await _getDatabase();
    var batch = db.batch();
    try {
      if (table == keyDebitTable) {
        Debit d = entry;
        var result;
        await db.transaction((txn) async {
          result = await txn.rawDelete("delete from $table where id = ?;",[d.id]);
        });
        print(result);
      } else if (table == keyCreditCardTable) {
        CreditCard c = entry;
        batch.delete(table, where: "id = ?", whereArgs: [c.id]);
        batch.delete(keyDebitTable,
            where: "$keyCreditCardIdDebit = ?", whereArgs: [c.id]);
        batch.delete(keyOwnerDebitTable,
            where: "$keyCreditCardIDOwnerDebit = ?", whereArgs: [c.id]);
        var results = await batch.commit();
        print(results);
      }
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
          return List<CreditCard>.generate(
              list.length, (index) => CreditCard().fromMap(list[index]));
          break;
        case keyOwnerTable:
          list = await db.query(table);
          return List<Owner>.generate(
              list.length, (index) => Owner().fromMap(list[index]));
          break;
        case keyDebitTable:
          list = await db.query(table,
              where: "$keyCreditCardIdDebit = ?", whereArgs: [whereArgs]);
          return List<Debit>.generate(
              list.length, (index) => Debit().fromMap(list[index]));
          break;
      }
    } catch (ex) {
      print(ex);
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Debit>> getDebitEntries(int cardId) async {
    List<Map<String, dynamic>> list;
    List<Map<String, dynamic>> selected;
    List<Debit> debitsList = [];
    List<int> idList = [];
    List<int> ids = [];
    List<Owner> owners = [];
    List<Owner> ownerList = await getEntries(keyOwnerTable);

    try {
      Database db = await _getDatabase();

      String query = "$SELECT_DEBITS ${cardId.toString()}";

      list = await db.rawQuery(query);

      list.forEach((element) {
        idList.add(element["debit_id"]);
      });

      ids = idList.toSet().toList();

      for (int i = 0; i < ids.length; i++) {
        await db.transaction((txn) async => selected =
            await txn.rawQuery("$SELECT_DEBITS_WHERE", [ids[i].toString()]));

        for (int i = 0; i < selected.length; i++) {
          if (selected != null)
            owners.add(_getOwner(ownerList, selected[i]["owner_id"]));
        }
        Debit d = Debit().fromMap(selected[0]);
        d.ownerId.addAll(owners);
        debitsList.add(d);
        owners.clear();
      }
      return debitsList;
    } catch (e) {
      print(e);
    }
  }

  Owner _getOwner(List<Owner> list, int id) {
    Owner owner;
    list.forEach((element) {
      if (element.id == id) owner = element;
    });
    return owner;
  }
}
