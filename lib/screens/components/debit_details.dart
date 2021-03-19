import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/debit.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class DebitDetails extends StatelessWidget {
  Debit debit;
  DebitDetails(this.debit);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
      init: ModelController(),
      builder: (value) {
        return GestureDetector(
          onTap:()=> value.getOwnersDebits(1),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Card(
                color: Colors.purple.shade600,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(debit.description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
                          Text(
                              "R\$: ${debit.value.toStringAsFixed(2)} X ${debit.quota.toString()} = R\$: ${(debit.value / debit.quota).toStringAsFixed(2)}",
                            style:TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            child: ListView.builder(
                                itemCount: debit.owners.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.white)),
                                      child: Text(debit.owners[index].name, style: TextStyle(fontSize: 12, color: Colors.white),));
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.delete), onPressed: (){
                    value.deleteDebit(debit);
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
