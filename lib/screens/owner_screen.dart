import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:get/get.dart';

class OwnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
        init: ModelController(),
        builder: (value) {
          List<Owner> owners = value.ownerList;
          return Scaffold(
            body: Container(
              child: ListView.builder(
                itemCount: owners.length,
                itemBuilder: (context, index){
                  Owner owner = owners[index];
                  return Container(
                    child: Row(
                      children: [
                        Text(owner.name)
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
