import 'package:gerenciador_cartoes/data/models/credit_card.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbRepository {
  Future<Database> _getDatabase() async {
    //deleteDatabase(DATABASE);
    return openDatabase(join(await getDatabasesPath(), DATABASE),
        onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (db, version) async {
      await db.execute(CREATE_CREDIT_CARD_TABLE);
      await db.execute(CREATE_OWNER_TABLE);
      await db.execute(CREATE_DEBIT_TABLE);
      await db.execute(CREATE_OWNER_DEBIT_TABLE);
    }, version: 1);
  }

  Future<int> insert(Map entry, String table) async {
    int id;
    try {
      final Database db = await _getDatabase();
      id = await db.insert(table, entry);
    } catch (ex) {
      print(ex);
    }
    return id;
  }

  Future<void> delete({String table, dynamic entry, int iD}) async {
    final Database db = await _getDatabase();
    try {
      var batch = db.batch();
      if (table == keyDebitTable) {
        Debit d = entry;
        await db.transaction((txn) async {
          txn.rawDelete("DELETE FROM debit WHERE id=?;", [d.id]);
        });
      } else if (table == keyCreditCardTable) {
        CreditCard c = entry;
        batch.delete(table, where: "id = ?", whereArgs: [c.id]);
        var results = await batch.commit();
        print(results);
      } else if (table == keyOwnerTable) {
        Owner owner = entry;
        batch.delete(keyOwnerDebitTable,
            where: "owner_id = ?", whereArgs: [owner.id]);
        batch.delete(table, where: "id = ?", whereArgs: [owner.id]);
        var results = await batch.commit();
        print(results);
      } else if (table == keyOwnerDebitTable) {
        String query =
            "DELETE FROM $keyOwnerDebitTable WHERE $keyDebitIDOwnerDebit = ? AND $keyOwnerIDOwnerDebit = ?";
        batch.rawDelete(query, [iD, entry.id]);
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
              list.length, (index) => CreditCard.fromMap(list[index]));
          break;
        case keyOwnerTable:
          list = await db.query(table);
          return List<Owner>.generate(
              list.length, (index) => Owner.fromMap(list[index]));
          break;
        case keyDebitTable:
          list = await db.query(table,
              where: "$keyCreditCardIdDebit = ?", whereArgs: [whereArgs]);
          return List<Debit>.generate(
              list.length, (index) => Debit.fromMap(list[index]));
          break;
      }
    } catch (ex) {
      print(ex);
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Debit>> getDebitEntries({int cardId, int ownerId}) async {
    List<Map<String, dynamic>> list;
    List<Debit> debitsList = [];

    try {
      Database db = await _getDatabase();

      if (ownerId != null) {
        String query = SELECT_DEBITS_WHERE_OWNER2;
        await db.transaction(
            (txn) async => list = await txn.rawQuery(query, [cardId, ownerId]));

        debitsList = List<Debit>.generate(
            list.length, (index) => Debit.fromMap(list[index]));
      } else {
        String query = "$SELECT_DEBITS ${cardId.toString()}";

        list = await db.rawQuery(query);

        await _setOwners(list).then((value) => debitsList = value);
      }
      return debitsList;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Debit>> _setOwners(List<Map<String, dynamic>> list) async {
    List<Map<String, dynamic>> selected;
    List<Debit> debits = [];
    List<int> idList = [];
    List<int> ids = [];
    List<Owner> owners = [];
    List<Owner> ownerList = await getEntries(keyOwnerTable);
    Database db = await _getDatabase();

    list.forEach((element) {
      idList.add(element["debit_id"]);
    });

    ids = idList.toSet().toList();

    for (int i = 0; i < ids.length; i++) {
      await db.transaction((txn) async => selected =
          await txn.rawQuery("$SELECT_DEBITS_WHERE2", [ids[i].toString()]));

      for (int i = 0; i < selected.length; i++) {
        if (selected != null)
          owners.add(_getOwner(ownerList, selected[i]["owner_id"]));
      }
      Debit d = Debit.fromMap(selected[0]);
      d.owners.addAll(owners);
      debits.add(d);
      owners.clear();
    }
    return debits;
  }

  Future<void> update(String table, Map entry, int id) async {
    final Database db = await _getDatabase();

    try {
      if (table == keyDebitTable) {
        db.transaction((txn) async {
          await txn.update(table, entry, where: "id = ?", whereArgs: [id]);
        });
      } else if (table == keyOwnerTable) {
        db.transaction((txn) async {
          await txn.update(table, entry, where: "id = ?", whereArgs: [id]);
        });
      } else if (table == keyCreditCardTable) {
        db.transaction((txn) async {
          await txn.update(table, entry, where: "id = ?", whereArgs: [id]);
        });
      }
    } catch (ex) {
      print(ex);
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
