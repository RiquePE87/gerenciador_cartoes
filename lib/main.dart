import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/screens/credit_card_screen.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gerenciador de Cartões'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.credit_card),
          onPressed: ()=> Get.to(CreditCardScreen()),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}