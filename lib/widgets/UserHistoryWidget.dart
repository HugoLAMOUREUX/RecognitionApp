import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHistoryWidget extends StatelessWidget {
  const UserHistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
          width: 350, //not responsive du tout
          height: 600,
         // decoration: BoxDecoration(color: Colors.red),
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int position) {
                return Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))

                    ),
                    child: Text("text $position"),);

              }));
  }
}
