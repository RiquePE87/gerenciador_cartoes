import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/controllers/model_controller.dart';
import 'package:gerenciador_cartoes/data/models/owner.dart';
import 'package:gerenciador_cartoes/screens/components/owner_details.dart';
import 'package:get/get.dart';

class OwnerScreen extends GetView<ModelController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade500,
      body: SafeArea(child: Obx(() {
        return Column(
          children: [
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Get.back())
              ],
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: controller.ownerList.length,
                  itemBuilder: (context, index) {
                    Owner owner = controller.ownerList[index];
                    return Obx(()=> controller.isLoading.value
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )),
                    )
                        : OwnerDetails(owner));
                  },
                ),
              ),
            ),
          ],
        );
      })),
    );
  }
}
