import 'package:flutter/material.dart';
import 'package:gerenciador_cartoes/screens/components/owner_dialog.dart';

class DebitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<String> list = [
      "um", "dois", "tres", "quatro"
    ];

    const OutlineInputBorder border =
    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)));

    return Dialog(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.all(10),
        color: Colors.grey[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration:
              InputDecoration(
                  isDense: true,
                  hintText: "Valor total R\$:", border: border),
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Número de parcelas", border: border),
            ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Descrição", border: border),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(onPressed: (){}, child: Text("Salvar")),
                FlatButton(onPressed: (){}, child: Text("Cancelar")),

              ],
            )
          ],
        ),
      ),
    );
  }
}
