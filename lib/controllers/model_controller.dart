import 'package:flutter/foundation.dart';
import 'package:gerenciador_cartoes/data/models/credit_card.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  final DbRepository dbRepository;
  ModelController({@required this.dbRepository});

  RxBool isLoading = true.obs;
  RxList<String> names = <String>[].obs;
  RxList<CreditCard> creditCards = <CreditCard>[].obs;
  RxList<Debit> debitsList = <Debit>[].obs;
  RxList<Owner> ownerList = <Owner>[].obs;
  RxList<Owner> selectedOwners = <Owner>[].obs;
  Rx<CreditCard> selectedCard = CreditCard().obs;
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  Rx<Debit> debit = new Debit().obs;
  RxString message = "".obs;

  _init() {
    ever(selectedOwners, (_) {
      names.clear();
      selectedOwners.forEach((element) {
        if (names.contains(element.name))
          names.remove(element.name);
        else
          names.add(element.name);
      });
    });
  }

  void updateAll() {
    getOwners();
    getDebits();
    getCreditCards();
  }

  Future<Map<String, double>> getTotalDebits(Owner owner) async {
    Map<String, double> list = {};
    List<Debit> debits = [];

    if (owner.debits.length > 0) {
      for (int i = 0; i < creditCards.length; i++) {
        double total = 0.0;
        var values = owner.debits.keys.toList();
        debits = owner.debits[values[i]];

        for (int j = 0; j < debits.length; j++) {
          var result =
              (debits[j].value / debits[j].quota) / debits[j].owners.length;
          total += result;
        }
        list[creditCards[i].name] = total;
        debits.clear();
        total = 0;
      }
    }

    print("Completado total");
    print(list);
    return list;
  }

  Future<Map<String, List<Debit>>> getOwnerDebits(Owner owner) async {
    Map<String, List<Debit>> debits = {};
    Map<String, List<Debit>> ownerDebits = {};

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
    print("Completado debitos");
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
    var list = <CreditCard>[];
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
    List<Owner> items = await dbRepository.getEntries(keyOwnerTable);
    ownerList.assignAll(items);

    for (int i = 0; i < ownerList.length; i++) {
      await getOwnerDebits(ownerList[i])
          .then((value) => ownerList[i].debits.addAll(value));
    }

    for (int i = 0; i < ownerList.length; i++) {
      await getTotalDebits(ownerList[i])
          .then((value) => ownerList[i].totalDebits.addAll(value))
          .whenComplete(() async => await getOwnerDebits(ownerList[i])
              .then((value) => ownerList[i].debits.addAll(value)));
    }
    isLoading.value = false;
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
    selectedOwners.forEach((element) async {
      if (!debit.owners.contains(element)) {
        Map<String, dynamic> map = {};
        map.addAll({
          "$keyOwnerIDOwnerDebit": element.id,
          "$keyDebitIDOwnerDebit": debit.id,
          "$keyCreditCardIDOwnerDebit": debit.creditCardId
        });
        await dbRepository.insert(map, keyOwnerDebitTable);
      }
    });

    debit.owners.forEach((element) async {
      if (!selectedOwners.contains(element)) {
        await dbRepository.delete(table: keyOwnerDebitTable, entry: element);
      }
    });

    await dbRepository.update(keyDebitTable, debit.toMap(), debit.id);
    Get.back();
    updateAll();
  }

  Future<void> updateOwner(Owner owner) async {
    await dbRepository.update(keyOwnerTable, owner.toMap(), owner.id);
    getOwners();
    Get.back();
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
    _init();
    getCreditCards();
    getOwners();
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
  }
}
