import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/data/models/credit_card.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  ModelController({@required this.dbRepository});
  final DbRepository dbRepository;
  CreditCard cc = new CreditCard();
  RxList<CreditCard> creditCards = <CreditCard>[].obs;
  Rx<Debit> debit = new Debit().obs;
  RxList<Debit> debitsList = <Debit>[].obs;
  RxBool isLoading = true.obs;
  RxString message = "".obs;
  RxList<String> names = <String>[].obs;
  Owner owner = new Owner();
  RxList<Owner> ownerList = <Owner>[].obs;
  final Rx<PageController> pageController =
      PageController(initialPage: DateTime.now().month - 1).obs;
  Rx<CreditCard> selectedCard = CreditCard().obs;
  RxList<int> selectedOwners = <int>[].obs;

  @override
  void onInit() async {
    super.onInit();
    _init();
  }

  @override
  void onReady() {
    updateAll();
    super.onReady();
  }

  _init() {
    ever(selectedOwners, (_) {
      names.clear();
      selectedOwners.forEach((e) {
        Owner element = ownerList.firstWhere((element) => element.id == e);
        if (names.contains(element.name))
          names.remove(element.name);
        else
          names.add(element.name);
      });
    });

    //ever(selectedCard, (_) => monthlyDebits.clear());
  }

  double setCardsTotal(Map cards, int month) {
    double total = 0;
    cards.forEach((key, value) {
      List<Debit> debits = value[month]["debits"];
      debits.forEach((element) {
        total += (element.value / element.quota) / element.owners.length;
      });
    });
    return total;
  }

  double setTotalDebit(RxList<Debit> debits) {
    double total = 0;

    debits.forEach((element) {
      total += element.value / element.quota;
    });

    return total;
  }

  void updateAll() {
    getCreditCards().whenComplete(() => getOwners());
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
    return list;
  }

  Future<Map<String, dynamic>> getOwnerDebits(Owner owner) async {
    Map<String, dynamic> ownerDebits = {};
    List<Map<String, dynamic>> deb;

    for (int i = 0; i < creditCards.length; i++) {
      deb = creditCards[i].monthDebits;

      for (int k = 0; k < creditCards[i].monthDebits.length; k++) {
        List<Debit> l = deb[i]["debits"];
        List<Debit> list = [];
        for (int j = 0; j > l.length; j++) {
          l[i].owners.forEach((o) {
            if (o.id == owner.id) {
              list.add(l[i]);
            }
            deb[i]["debits"].addAll(list);
          });
        }
      }
      ownerDebits[creditCards[i].name] = deb;
    }
    return ownerDebits;

    // ownerDebits.forEach((key, value) {
    //   List<Debit> l = [];
    //   value.forEach((element) {
    //     for (Owner o in element.owners) {
    //       if (o.id == owner.id) {
    //         l.add(element);
    //       }
    //     }
    //   });
    //   //debits[key] = l;
    // });
    // print(debits);
    // //return debits;
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
        selectedOwners.length != 0 &&
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
    for (int i = 0; i < list.length; i++) {
      await getMonthlyDebits(list[i])
          .then((value) => list[i].monthDebits = value);
    }
    if (list.length != 0) {
      creditCards.assignAll(list);
      creditCards.refresh();
      update(creditCards);
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyDebits(CreditCard card) async {
    List<Map<String, dynamic>> debits = [];
    //if (monthlyDebits.length == 0) {
    for (int i = 1; i <= DateTime.monthsPerYear; i++)
      await getDebitsByMonth(i, card).then((value) {
        Map<String, dynamic> map = {
          "month": DateTime(DateTime.now().year, i),
          "debits": value,
          "total": setTotalDebit(value)
        };
        debits.add(map);
      });
    // } else {
    //   monthlyDebits.refresh();
    // }
    return debits;
  }

  Future<List<Debit>> _getDebits(CreditCard card) async {
    RxList<Debit> allDebits = <Debit>[].obs;

    isLoading.value = true;
    List<Debit> items =
        await dbRepository.getDebitEntries(cardId: card.id).whenComplete(() {
      isLoading.value = false;
    });
    allDebits.assignAll(items);

    return allDebits;
  }

  Future<RxList<Debit>> getDebitsByMonth(int month, CreditCard card) async {
    RxList<Debit> monthDebits = <Debit>[].obs;
    List<Debit> allDebits = [];

    await _getDebits(card).then((value) => allDebits.assignAll(value));

    allDebits.forEach((element) {
      if (element.months.contains(month)) {
        monthDebits.add(element);
      }
    });

    //selectedCard.value.monthDebits = monthDebits;

    return monthDebits;
  }

  void selectOwners(Owner owner) {
    if (selectedOwners.contains(owner.id))
      selectedOwners.remove(owner.id);
    else
      selectedOwners.add(owner.id);
  }

  Future<void> getOwners() async {
    isLoading.value = true;
    List<Owner> items = await dbRepository.getEntries(keyOwnerTable);
    ownerList.assignAll(items);

    for (int i = 0; i < ownerList.length; i++) {
      await getOwnerDebits(ownerList[i])
          .then((value) => ownerList[i].debits = value);

      // await getTotalDebits(ownerList[i])
      //     .then((value) => ownerList[i].totalDebits.addAll(value))
      //     .whenComplete(() async => await getOwnerDebits(ownerList[i])
      //         .then((value) => ownerList[i].debits.addAll(value)));
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
    debit.value.bestDay = selectedCard.value.bestDay;
    if (validateDebit()) {
      int debitId;
      debitId = await dbRepository.insert(debit.value.toMap(), keyDebitTable);
      selectedOwners.forEach((e) async {
        Map<String, dynamic> map = {};
        map.addAll({
          "$keyOwnerIDOwnerDebit": e,
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

  void updateDebitView(CreditCard card, int debitId) async {
    // Debit d = await dbRepository.g
  }

  Future<void> insertCreditCard() async {
    if (validateCreditCard() == true) {
      dbRepository.insert(cc.toMap(), keyCreditCardTable);
      getCreditCards();
      Get.back();
    }
  }

  Future<void> updateCreditCard(CreditCard creditCard) async {
    await dbRepository.update(
        keyCreditCardTable, creditCard.toMap(), creditCard.id);
    getCreditCards();
    //selectedCard.refresh();
    Get.back();
  }

  Future<void> updateDebit(Debit debit) async {
    List<int> owners = [];
    selectedOwners.forEach((id) async {
      debit.owners.forEach((element) {
        owners.add(element.id);
      });

      if (!owners.contains(id)) {
        Map<String, dynamic> map = {};
        map.addAll({
          "$keyOwnerIDOwnerDebit": id,
          "$keyDebitIDOwnerDebit": debit.id,
          "$keyCreditCardIDOwnerDebit": debit.creditCardId
        });
        await dbRepository.insert(map, keyOwnerDebitTable);
      }
    });

    debit.owners.forEach((element) async {
      if (!selectedOwners.contains(element.id)) {
        await dbRepository.delete(
            table: keyOwnerDebitTable, entry: element, iD: debit.id);
      }
    });

    await dbRepository.update(keyDebitTable, debit.toMap(), debit.id);
    Get.back();
    //getMonthlyDebits();
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
    await dbRepository.delete(table: keyDebitTable, entry: debit);
    Get.snackbar("Débito Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        duration: Duration(seconds: 2));
    updateAll();
    Get.back();
  }

  Future<void> deleteOwner(Owner owner) async {
    await dbRepository.delete(table: keyOwnerTable, entry: owner);
    Get.snackbar("Devedor Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM);
    updateAll();
    Get.back();
  }
}
