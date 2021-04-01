import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/screens/dialogs/owner_select_dialog.dart';
import 'package:get/get.dart';

class DebitDialog extends StatelessWidget {

  final Debit debit;

  DebitDialog({this.debit});

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border =
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)));

    return Dialog(
        child: GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: debit != null ? debit.value.toString() : "",
                  // ignore: null_aware_before_operator
                  onChanged: (txt) => debit != null ? debit.value = double?.tryParse((txt.replaceAll(RegExp("[^0-9]"), ""))) / 100
                      : value.debit.value.value = double.tryParse(txt.replaceAll(RegExp("[^0-9]"), "")) / 100,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true, moeda: true)
                  ],
                  decoration: InputDecoration(
                      isDense: true,

                      hintText: "Valor total R\$:",
                      border: border),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: debit != null ? debit.quota.toString() : "",
                  onChanged: (txt) => debit != null ? debit.quota = int?.parse(txt) : value.debit.value.quota = int.tryParse(txt),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Número de parcelas",
                      border: border),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(()=> Text(value.debit.value.purchaseDate == null ? "Data da compra" :
                    "${formatDate(value.debit.value.purchaseDate)}"),),
                    IconButton(icon: Icon(Icons.calendar_today), color: Colors.black, onPressed: () async{
                      value.debit.value.purchaseDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                    })
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: debit != null ? debit.description : "",
                  onChanged: (txt) => debit != null ? debit.description = txt : value.debit.value.description = txt,
                  decoration: InputDecoration(
                      isDense: true, hintText: "Descrição", border: border),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.black87,
                        ),
                        onPressed: () => Get.dialog(OwnerSelectDialog(owners: debit?.owners)))
                  ],
                ),
                Obx(() => Text("${value.message}")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          debit == null ? value.insertDebit() : value.updateDebit(debit);
                        },
                        child: Text("Salvar")),
                    TextButton(
                        onPressed: () {
                          Get.back();
                          value.debit.value = new Debit();
                        },
                        child: Text("Cancelar")),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ));
  }
  
  String formatDate(DateTime date){
    return "${date.day}/${date.month}/${date.year}";
  }
}
