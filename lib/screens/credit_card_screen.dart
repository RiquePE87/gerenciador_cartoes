import 'package:flutter/material.dart';

class CreditCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Cartão"),
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.grey,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Nome do cartão"
              ),
            ),
            Container(
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded),
                  Text("Vencimento")
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Limite do cartão"
              ),
            )
          ],
        ),
      ),
    );
  }
}
