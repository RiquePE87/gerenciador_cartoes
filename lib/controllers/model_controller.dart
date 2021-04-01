import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  var isLoading = true.obs;
  var creditCards = <CreditCard>[].obs;
  var debitsList = <Debit>[].obs;
  var ownerList = <Owner>[].obs;
  var selectedOwners = <Owner>[].obs;
  var selectedCard = CreditCard().obs;
  var list = <CreditCard>[];
  DbRepository dbRepository = DbRepository();
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  var debit = new Debit().obs;
  var message = "".obs;
  var ownerDebits = Map<String, List<Debit>>().obs;

  void updateAll() {
    getOwners();
    getDebits();
    getCreditCards();
  }

  Future<Map<String, List<Debit>>> getOwnerDebits(Owner owner) async {
    Map<String, List<Debit>> debits = {};

    for (int i = 0; i < creditCards.length; i++) {
      List<Debit> list =
          await dbRepository.getDebitEntries(cardId: creditCards[i].id);
      ownerDebits[creditCards[i].name] = list;
    }
    ownerDebits.forEach((key, value) {
      List<Debit> l = [];
      value.forEach((element) {
        for (Owner o in element.owners) {
          if (o.id == owner.id) {
            l.add(element);
          }
        }
      });
      debits[key] = l;
    });
    return debits;
  }

  void showErrorMessage(String error) {
    message.value = error;
    Future.delayed(Duration(milliseconds: 2000), () {
      message.value = "";
    });
  }

  bool validateCreditCard() {
    if (cc.name != null &&
        cc.payDay != null &&
        cc.bestDay != null &&
        cc.usedLimit != null &&
        cc.limitCredit != null)
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
    if (debit.value.description != null &&
        debit.value.value != null &&
        debit.value.quota != null &&
        debit.value.purchaseDate != null) {
      return true;
    } else {
      showErrorMessage("Campo Obrigatório");
      return false;
    }
  }

  Future<void> getCreditCards() async {
    isLoading.value = true;
    list = await dbRepository.getEntries(keyCreditCardTable).whenComplete(() {
      isLoading.value = false;
    });
    if (list.length != 0) creditCards.assignAll(list);
  }

  Future<void> getDebits() async {
    isLoading.value = true;
    List<Debit> items = await dbRepository
        .getDebitEntries(cardId: selectedCard.value.id)
        .whenComplete(() {
      isLoading.value = false;
    });
    debitsList.assignAll(items);
    selectedCard.value.debits = debitsList;
  }

  void selectOwners(Owner owner) {
    if (selectedOwners.contains(owner))
      selectedOwners.remove(owner);
    else
      selectedOwners.add(owner);
  }

  Future<void> getOwners() async {
    isLoading.value = true;
    List<Owner> items = await dbRepository
        .getEntries(keyOwnerTable)
        .whenComplete(() => isLoading.value = false);
    ownerList.assignAll(items);
    for (int i = 0; i < ownerList.length; i++) {
      ownerList[i].debits = await getOwnerDebits(ownerList[i]);
    }
    //print(ownerList[0].debits);
  }

  Future<void> insertOwner() async {
    if (validateOwner()) {
      await dbRepository.insert(owner.toMap(), keyOwnerTable);
      getOwners();
      Get.back();
    }
  }

  Future<void> insertDebit() async {
    debit.value.creditCardId = selectedCard.value.id;
    if (validateDebit()) {
      int debitId;
      debitId = await dbRepository.insert(debit.value.toMap(), keyDebitTable);
      selectedOwners.forEach((e) async {
        Map<String, dynamic> map = {};
        map.addAll({
          "$keyOwnerIDOwnerDebit": e.id,
          "$keyDebitIDOwnerDebit": debitId,
          "$keyCreditCardIDOwnerDebit": debit.value.creditCardId
        });
        await dbRepository.insert(map, keyOwnerDebitTable);
      });
      selectedOwners.clear();
      updateAll();
      Get.back();
    }
  }

  Future<void> insertCreditCard() async {
    if (validateCreditCard() == true) {
      dbRepository.insert(cc.toMap(), keyCreditCardTable);
      getCreditCards();
      Get.back();
    }
  }

  Future<void> updateDebit(Debit debit) async {
    await dbRepository.update(keyDebitTable, debit.toMap(), debit.id);
    Get.back();
    updateAll();
  }

  Future<void> updateOwner(Owner owner) async {
    await dbRepository.update(keyOwnerTable, owner.toMap(), owner.id);
    Get.back();
    getOwners();
  }

  Future<void> deleteCreditCard(CreditCard card) async {
    await dbRepository.delete(table: keyCreditCardTable, entry: card);
    Get.snackbar("Cartão Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM);
    updateAll();
  }

  Future<void> deleteDebit(Debit debit) async {
    //await dbRepository.deleteDebit(debit);
    await dbRepository.delete(table: keyDebitTable, entry: debit);
    Get.snackbar("Débito Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        duration: Duration(seconds: 2));
    updateAll();
  }

  Future<void> deleteOwner(Owner owner) async {
    await dbRepository.delete(table: keyOwnerTable, entry: owner);
    Get.snackbar("Devedor Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM);
    updateAll();
    Get.back();
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
