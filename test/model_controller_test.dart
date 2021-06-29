import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/repositories/db_repository.dart';
import 'package:get/get.dart';

main() {
  ModelController controller =
      Get.put(ModelController(dbRepository: DbRepository()));
  Owner owner = Owner(id: 1, name: "Henrique", debits: {}, totalDebits: {});
  RxList<Debit> debits = RxList();
  Debit debit = Debit(
      payedQuotas: 2,
      purchaseDate: DateTime.now(),
      quota: 5,
      value: 700.0,
      id: 1,
      bestDay: 21,
      creditCardId: 1,
      description: "Teste",
      months: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      owners: [owner]);
  debits.add(debit);
  test("Checks if creditcard list will be created properly", () async {
    await controller.getCreditCards();

    expectLater(
        controller.creditCards.length, controller.creditCards.length != 0);
  });

  test("Get total amount of debits", () {
    double result = controller.setTotalDebit(debits);

    expect(result, 140.0);
  });
}
