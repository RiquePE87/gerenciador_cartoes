import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  var isLoading = true;
  var creditCards = <dynamic>[];
  var debitsList = <dynamic>[];
  var ownerList = <dynamic>[];
  var selectedOwners = <dynamic>[];
  var name;
  var payDay;
  var usedLimit;
  var limitCredit;
  CreditCard selectedCard;
  DbRepository dbRepository = DbRepository();
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  Debit debit = new Debit();
  var message = "";

  void getTotalDebit() {
    selectedCard.total = 0.0;
    debitsList.forEach((element) {
      selectedCard.total += (element.value / element.quota);
    });
  }

  void showErrorMessage(String error) {
    message = error;
    update();
    Future.delayed(Duration(milliseconds: 2000), () {
      message = "";
      update();
    });
  }

  bool validateCreditCard() {
    if (name != null &&
        payDay != null &&
        usedLimit != null &&
        limitCredit != null)
      return true;
    else {
      showErrorMessage("Campo Obrigatório");

      return false;
    }
  }

  bool validateOwner() {
    if (owner.name != null) {
      return true;
    } else {
      showErrorMessage("Campo Obrigatório");
      return false;
    }
  }

  bool validateDebit() {
    if (debit.description != null &&
        debit.value != null &&
        debit.quota != null &&
        debit.ownerId != null) {
      return true;
    } else {
      showErrorMessage("Campo Obrigatório");
      return false;
    }
  }

  Future<void> getCreditCards() async {
    isLoading = false;
    creditCards = await dbRepository
        .getEntries(keyCreditCardTable)
        .whenComplete(() => isLoading = false);
    update();
  }

  Future<void> getDebits() async {
    isLoading = true;
    debitsList = await dbRepository
        .getDebitEntries(selectedCard.id)
        .whenComplete(() => isLoading = false);
    getTotalDebit();
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
    if (validateOwner()) {
      await dbRepository.insert(owner.toMap(), keyOwnerTable);
      getOwners();
      update();
      Get.back();
    }
  }

  Future<void> insertDebit() async {
    if (validateDebit()) {
      debit.creditCardId = selectedCard.id;
      int debitId;
      debitId = await dbRepository.insert(debit.toMap(), keyDebitTable);
      selectedOwners.forEach((e) async {
        Map<String, dynamic> map = {};
        map.addAll(
            {"$keyOwnerIDOwnerDebit": e.id, "$keyDebitIDOwnerDebit": debitId});
        await dbRepository.insert(map, keyOwnerDebitTable);
      });
      update();
      Get.back();
    }
  }

  Future<void> insertCreditCard() async {
    if (validateCreditCard() == true) {
      cc.name = name;
      cc.payDay = int.tryParse(payDay);
      cc.limitCredit = double.tryParse(limitCredit);
      cc.usedLimit = double.tryParse(usedLimit);
      dbRepository.insert(cc.toMap(), keyCreditCardTable);
      getCreditCards();
      update();
      Get.back();
    }
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
    super.onInit();
  }
}
