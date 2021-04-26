import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/debit.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:get/get.dart';

class DebitDialog extends GetView<ModelController> {
  final Debit debit;
  List<String> names = [];
  //final ModelController controller = Get.find<ModelController>();

  DebitDialog({this.debit});

  @override
  Widget build(BuildContext context) {
    controller.selectedOwners.clear();

    if (debit != null) if (debit.owners != null) {
      debit.owners.forEach((element) {
        controller.selectOwners(element);
      });
      //controller.selectedOwners.assignAll(debit.owners);
    }

    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)));

    return Dialog(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: debit != null ? debit.value.toString() : "",
              // ignore: null_aware_before_operator
              onChanged: (txt) => debit != null
                  ? debit.value =
                      double.tryParse((txt.replaceAll(RegExp("[^0-9]"), ""))) /
                          100
                  : controller.debit.value.value =
                      double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) /
                          100,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: true, moeda: true)
              ],
              decoration: InputDecoration(
                  isDense: true, hintText: "Valor total R\$:", border: border),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: debit != null ? debit.quota.toString() : "",
              onChanged: (txt) => debit != null
                  ? debit.quota = int?.parse(txt)
                  : controller.debit.value.quota = int.tryParse(txt),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Número de parcelas",
                  border: border),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    setDateText(controller.debit.value.purchaseDate),
                    IconButton(
                        icon: Icon(Icons.calendar_today),
                        color: Colors.black,
                        onPressed: () async {
                          controller.debit.value.purchaseDate =
                              await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          controller.debit.refresh();
                        })
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              initialValue: debit != null ? debit.description : "",
              onChanged: (txt) => debit != null
                  ? debit.description = txt
                  : controller.debit.value.description = txt,
              decoration: InputDecoration(
                  isDense: true, hintText: "Descrição", border: border),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.ownerList.length,
                    itemBuilder: (context, index) {
                      final Owner owner = controller.ownerList[index];
                      return Obx(() => setButtonState(owner));
                    }),
              ),
            ),
            Obx(() => Text("${controller.message}")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      debit == null
                          ? controller.insertDebit()
                          : controller.updateDebit(debit);
                    },
                    child: Text("Salvar")),
                TextButton(
                    onPressed: () {
                      Get.back();
                      controller.debit.value = new Debit();
                    },
                    child: Text("Cancelar")),
              ],
            )
          ],
        ),
      ),
    ));
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget setDateText(DateTime date) {
    if (debit != null) {
      return Text(formatDate(debit.purchaseDate));
    } else if (controller.debit.value.purchaseDate == null) {
      return Text("Data de Compra");
    } else {
      return Text("${formatDate(date)}");
    }
  }

  Widget setButtonState(Owner owner) {
    Widget button;

    if (controller.names.contains(owner.name)) {
      button = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple)),
            onPressed: () => controller.selectOwners(owner),
            child: Text("${owner.name}")),
      );
    } else {
      button = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () => controller.selectOwners(owner),
            child: Text(
              "${owner.name}",
              style: TextStyle(color: Colors.black),
            )),
      );
    }
    return button;
  }
}
