import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  var isLoading = true;
  var creditCards = new List<dynamic>();
  var debitsList = new List<dynamic>();
  var ownerList = new List<dynamic>();
  var selectedOwners = new List<dynamic>();
  var name;
  var payDay;
  var usedLimit;
  var limitCredit;
  CreditCard selectedCard;
  DbRepository dbRepository = DbRepository();
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  Debit debit = new Debit();

  Future<void> getCreditCards() async {
    isLoading = false;
    creditCards = await dbRepository
        .getEntries(keyCreditCardTable)
        .whenComplete(() => isLoading = false);
    update();
  }

  Future<void> getDebits() async {
    isLoading = false;
    debitsList = await dbRepository.getDebitsEntries();
    // debitsList = await dbRepository
    //     .getEntries(keyDebitTable, whereArgs: selectedCard.id)
    //     .whenComplete(() => isLoading = false);
    update();
  }

  void selectOwners(Owner owner) {
    if (selectedOwners.contains(owner))
      selectedOwners.remove(owner);
    else
      selectedOwners.add(owner);
    update();
  }

  Future<void> getOwners() async {
    isLoading = false;
    ownerList = await dbRepository
        .getEntries(keyOwnerTable)
        .whenComplete(() => isLoading = false);
    update();
  }

  Future<void> insertOwner() async {
    await dbRepository.insert(owner.toMap(), keyOwnerTable);
    getOwners();
    update();
  }

  Future<void> insertDebit() async {
    debit.creditCardId = selectedCard.id;
    int debitId;
    Map<String, dynamic> map = {};
    debitId = await dbRepository.insert(debit.toMap(), keyDebitTable);
    selectedOwners.forEach((e) async {
      Map<String, dynamic> map = {};
      map.addAll(
          {"$keyOwnerIDOwnerDebit": e.id, "$keyDebitIDOwnerDebit": debitId});
      await dbRepository.insert(map, keyOwnerDebitTable);
    });
    update();
  }

  Future<void> insertCreditCard() async {
    cc.name = name;
    cc.payDay = int.tryParse(payDay);
    cc.limitCredit = double.tryParse(limitCredit);
    cc.usedLimit = double.tryParse(usedLimit);
    dbRepository.insert(cc.toMap(), keyCreditCardTable);
    getCreditCards();
    update();
  }

  Future<void> deleteCreditCard(CreditCard card) async {
    await dbRepository.delete(card);
    getCreditCards();
    Get.snackbar("Cartão Excluido!", "Excluido com sucesso!");
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() async {
    getCreditCards();
    getOwners();
    //getDebits();
    super.onInit();
  }
}
