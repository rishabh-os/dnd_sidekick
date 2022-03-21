import "dart:core";
import "package:flutter/material.dart";

import "../Components/DataLoader.dart";

class Classes extends StatefulWidget {
  Classes({Key? key}) : super(key: key);

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Classes"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: DndData.classNamesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/classInfo",
                              arguments: {"index": index});
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 35,
                            child: Text(
                              "${DndData.classNamesList[index]}",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
