import 'package:gerenciador_cartoes/models/credit_card.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/constants.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

class ModelController extends GetxController {
  var isLoading = true;
  var creditCards = <CreditCard>[].obs;
  var debitsList = <Debit>[].obs;
  var ownerList = <Owner>[].obs;
  var selectedOwners = <Owner>[].obs;
  var name;
  var payDay;
  var usedLimit;
  var limitCredit;
  CreditCard selectedCard;
  DbRepository dbRepository = DbRepository();
  CreditCard cc = new CreditCard();
  Owner owner = new Owner();
  Debit debit = new Debit();
  var message = "".obs;
 var ownerDebits =  Map<String, List<Debit>>().obs;

  // void getTotalDebit() {
  //   selectedCard.total = 0.0;
  //   if (debitsList != null)
  //     debitsList.forEach((element) {
  //       selectedCard.total += (element.value / element.quota);
  //     });
  //   update();
  // }

  Future<Map<String, List<Debit>>> getOwnerDebits(Owner owner) async {
    Map<String, List<Debit>> debits = {};

    for (int i=0; i < creditCards.length; i++){
      List<Debit> list = await dbRepository.getDebitEntries(cardId: creditCards[i].id);
      ownerDebits[creditCards[i].name] = list;
    }
   ownerDebits.forEach((key, value) {
     List<Debit> l = [];
     value.forEach((element) {
       for (Owner o in element.owners){
         if (o.id == owner.id){
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
    Future.delayed(Duration(milliseconds: 2000),(){
      message.value = "";
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
        debit.quota != null) {
      return true;
    } else {
      showErrorMessage("Campo Obrigatório");
      return false;
    }
  }

  Future<void> getCreditCards() async {
    isLoading = true;
    creditCards.value = await dbRepository
        .getEntries(keyCreditCardTable)
        .whenComplete(() => isLoading = false);
    //update();
  }

  Future<void> getDebits() async {
    isLoading = true;
    debitsList.value = await dbRepository
        .getDebitEntries(cardId: selectedCard.id)
        .whenComplete(() {
      isLoading = false;
      selectedCard.debits = debitsList;
      //getTotalDebit();
      //update();
    });
  }

  void selectOwners(Owner owner) {
    if (selectedOwners.contains(owner))
      selectedOwners.remove(owner);
    else
      selectedOwners.add(owner);
    //update();
  }

  Future<void> getOwners() async {
    isLoading = false;
    ownerList.value = await dbRepository
        .getEntries(keyOwnerTable)
        .whenComplete(() => isLoading = false);
    for (int i=0; i < ownerList.length; i++){
      ownerList[i].debits = await getOwnerDebits(ownerList[i]);
    }
    //update();
  }

  Future<void> insertOwner() async {
    if (validateOwner()) {
      await dbRepository.insert(owner.toMap(), keyOwnerTable);
      getOwners();
      update();
    }
  }

  // Future<Map<String, List<Debit>>> getOwnersDebits(int ownerId) async {
  //   for (int i = 0; i < creditCards.length; i++) {
  //     List<Debit> list = await dbRepository.getDebitEntries(
  //         cardId: creditCards[i].id, ownerId: ownerId);
  //     ownerDebits[creditCards[i].name] = list;
  //   }
  //   update();
  //   return ownerDebits;
  //
  // }

  Future<void> insertDebit() async {
    debit.creditCardId = selectedCard.id;
    if (validateDebit()) {
      int debitId;
      debitId = await dbRepository.insert(debit.toMap(), keyDebitTable);
      selectedOwners.forEach((e) async {
        Map<String, dynamic> map = {};
        map.addAll({
          "$keyOwnerIDOwnerDebit": e.id,
          "$keyDebitIDOwnerDebit": debitId,
          "$keyCreditCardIDOwnerDebit": debit.creditCardId
        });
        await dbRepository.insert(map, keyOwnerDebitTable);
      });
      selectedOwners.clear();
      getDebits();
      //getTotalDebit();
      update();
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
    }
  }

  Future<void> deleteCreditCard(CreditCard card) async {
    await dbRepository.delete(table: keyCreditCardTable, entry: card);
    Get.snackbar("Cartão Excluido!", "Excluido com sucesso!",
        snackPosition: SnackPosition.BOTTOM);
    getCreditCards();
  }

  Future<void> deleteDebit(Debit debit) async {
    await dbRepository
        .delete(table: keyDebitTable, entry: debit)
        .whenComplete(() {
      Get.snackbar("Débito Excluido!", "Excluido com sucesso!",
          snackPosition: SnackPosition.BOTTOM, isDismissible: true, duration: Duration(seconds: 2));
      getDebits();
    });
  }

  @override
  void onReady() {
    getCreditCards();
    getOwners();
    super.onReady();
  }

  @override
  void onInit() async {
    getCreditCards();
    getOwners();
    super.onInit();
  }
}
