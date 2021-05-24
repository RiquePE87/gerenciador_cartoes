import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  RxList<Map<String, dynamic>> monthlyDebits = <Map<String, dynamic>>[].obs;
  RxList<Owner> ownerList = <Owner>[].obs;
  RxList<int> selectedOwners = <int>[].obs;
  Rx<CreditCard> selectedCard = CreditCard().obs;
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  Rx<Debit> debit = new Debit().obs;
  RxString message = "".obs;
  RxInt page = 1.obs;
  int lastMonth;
  int firstMonth;
  final Rx<PageController> pageController = PageController(initialPage: 1).obs;

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

    ever(selectedCard, (_) => monthlyDebits.clear());

    ever(page, (_) async {
      //print(page);
      if (monthlyDebits.length == page.value + 1 && lastMonth < 12) {
        lastMonth++;
        await getDebitsByMonth(lastMonth).then((item) => monthlyDebits.insert(
                monthlyDebits.length, {
              "month": lastMonth,
              "debits": item,
              "total": setTotalDebit(item)
            }));
      } else if (page.value == 0 && firstMonth > 1
          //&& monthlyDebits[0]["month"] != firstMonth
      ) {
        firstMonth--;
          await getDebitsByMonth(firstMonth).then((item) {
            monthlyDebits.insert(0, {
              "month": firstMonth,
              "debits": item,
              "total": setTotalDebit(item)
            });
          });
      }
      else{

      }
    });
  }

  double setTotalDebit(RxList<Debit> debits) {
    double total = 0;

    debits.forEach((element) {
      total += element.value / element.quota;
    });

    return total;
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

  Future<void> getMonthlyDebits() async {
    int numberOfMonths = 3;
    int selectedMonth = 0;
    int initialMonth = DateTime.now().month;
    if (monthlyDebits.length == 0) {
      lastMonth = initialMonth + 1;
      firstMonth = initialMonth - 1;
      selectedMonth = firstMonth;
      for (int i = 0; i < numberOfMonths; i++)
        await getDebitsByMonth(selectedMonth).then((value) {
          Map<String, dynamic> map = {
            "month": selectedMonth,
            "debits": value,
            "total": setTotalDebit(value)
          };
          monthlyDebits.add(map);
          selectedMonth++;
        });
    }
  }

  Future<RxList<Debit>> getDebitsByMonth(int month) async {
    RxList<Debit> monthDebits = <Debit>[].obs;
    RxList<Debit> allDebits = <Debit>[].obs;

    isLoading.value = true;
    List<Debit> items = await dbRepository
        .getDebitEntries(cardId: selectedCard.value.id)
        .whenComplete(() {
      isLoading.value = false;
    });
    allDebits.assignAll(items);

    allDebits.forEach((element) {
      if (element.months.contains(month)) {
        monthDebits.add(element);
      }
    });

    selectedCard.value.monthDebits = monthDebits;

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
      getMonthlyDebits();
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

  Future<void> updateCreditCard(CreditCard creditCard) async {
    await dbRepository.update(
        keyCreditCardTable, creditCard.toMap(), creditCard.id);
    getCreditCards();
    selectedCard.refresh();
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
