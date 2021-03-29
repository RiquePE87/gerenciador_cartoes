import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/models/owner.dart';
import 'package:gerenciador_cartoes/screens/components/owner_details.dart';
import 'package:get/get.dart';

class OwnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
        init: ModelController(),
        builder: (value) {
          List<Owner> owners = value.ownerList;
          return Scaffold(
            backgroundColor: Colors.purple.shade500,
            body: SafeArea(
              child: Obx(()=> Container(
                child: ListView.builder(
                  itemCount: owners.length,
                  itemBuilder: (context, index){
                    Owner owner = owners[index];
                    return value.isLoading.value ? Center(child: CircularProgressIndicator()) : OwnerDetails(owner);
                  },
                ),
              ),)
            ),
          );
        });
  }
}
