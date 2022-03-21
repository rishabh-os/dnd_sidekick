import "package:flutter/material.dart";
import "package:sliver_tools/sliver_tools.dart";
import "../Components/DataLoader.dart";

class ClassInfo extends StatefulWidget {
  ClassInfo({Key? key}) : super(key: key);

  @override
  _ClassInfoState createState() => _ClassInfoState();
}

class _ClassInfoState extends State<ClassInfo> {
  Map? data = {};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
    final classDetails = DndData.fullClasses[data!["index"]]["class"][0];
    final List<String> colNames = [
      "Total Cantrips Known",
      "Total Spells Known",
      "Sorcery Points",
      "Spells Known of Each Level"
    ];
    final List<List<dynamic>?> tableData = [
      classDetails["cantripProgression"],
      classDetails["spellsKnownProgression"],
      classDetails["classTableGroups"][0]["rows"],
      classDetails["classTableGroups"][2]["rows"]
    ];
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        controller: ScrollController(),
        slivers: [
          MultiSliver(pushPinnedChildren: true, children: [
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverPinnedHeader(child: _CardHeader(title: "Main Stats")),
                SliverList(
                  delegate: mainStatsDelegate(classDetails),
                ),
              ],
            ),
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverPinnedHeader(
                    child: _CardHeader(
                  title: "Level Table",
                )),
                Container(
                  height: 400,
                  width: double.infinity,
                  // child: StickyHeadersTable(
                  //     cellDimensions: CellDimensions.fixed(
                  //         contentCellWidth: 150,
                  //         contentCellHeight: 50,
                  //         stickyLegendWidth: 50,
                  //         stickyLegendHeight: 50),
                  //     legendCell: Text("Level"),
                  //     columnsLength: 4,
                  //     rowsLength: 20,
                  //     columnsTitleBuilder: (i) => Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text("${colNames[i]}"),
                  //         ),
                  //     rowsTitleBuilder: (i) => Text("${i + 1}"),
                  //     contentCellBuilder: (i, j) {
                  //       if (i == 2) {
                  //         return Text("${tableData[i]![j][0]}");
                  //       } else {
                  //         return Text("${tableData[i]![j]}");
                  //       }
                  //     }),
                )
              ],
            ),
            for (var i in classDetails["classFeatures"]) Text("$i")
          ])
        ],
      ),
    ));
  }

  SliverChildListDelegate mainStatsDelegate(classDetails) {
    return SliverChildListDelegate(
      [
        ListTile(
          title: Text(
            "Hit dice: 1d${classDetails["hd"]["faces"]}",
          ),
        ),
        ListTile(
          title: Text(
              "Proficiences: ${classDetails["proficiency"][0]}, ${classDetails["proficiency"][1]}"),
        ),
        ListTile(
          title: Text(
              "Spellcasting Ability: ${classDetails["spellcastingAbility"]}"),
        ),
        ListTile(
          title: Text("Starting Weapon Proficiencies"),
          subtitle: Column(
            children: [
              for (var i in classDetails["startingProficiencies"]["weapons"])
                Text(">>${i.toString().split("|").last.capitalizeFirstofEach}")
            ],
          ),
        ),
        ListTile(
          title: Text("Starting Skills (choose 2)"),
          subtitle: Column(
            children: [
              for (var i in classDetails["startingProficiencies"]["skills"][0]
                  ["choose"]["from"])
                Text(">>${i.toString().split("|").last.capitalizeFirstofEach}")
            ],
          ),
        )
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;

  const _CardHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

//               Table(
//                 columnWidths: {
//                   0: FlexColumnWidth(1),
//                   1: FlexColumnWidth(1),
//                   2: FlexColumnWidth(1),
//                 },
//                 children: [
//                   TableRow(children: [
//                     Center(child: Text("Level")),
//                     Center(child: Text("Total Cantrips Known")),
//                     Center(child: Text("Total Spells Known")),
//                     Center(child: Text("Sorcery Points"))
//                   ]),
//                   for (var x in [for (var i = 0; i < 20; i += 1) i])
//                     TableRow(children: [
//                       Center(child: Text("${x + 1}")),
//                       Center(
//                           child:
//                               Text("${classDetails["cantripProgression"][x]}")),
//                       Center(
//                           child: Text(
//                               "${classDetails["spellsKnownProgression"][x]}")),
//                       Center(
//                           child: Text(
//                               "${classDetails["classTableGroups"][0]["rows"][x][0]}"))
//                     ])
//                 ],
//               ),
//               Table(
//                 columnWidths: {
//                   0: FlexColumnWidth(1),
//                   1: FlexColumnWidth(1),
//                 },
//                 children: [
//                   TableRow(children: [
//                     Center(child: Text("Level")),
//                     for (var x in [for (var i = 0; i < 9; i += 1) i])
//                       Center(
//                           child: Text(
//                         "${x + 1}",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       )),
//                   ]),
//                   for (var x in [for (var i = 0; i < 20; i += 1) i])
//                     TableRow(children: [
//                       Center(child: Text("${x + 1}")),
//                       for (var y in classDetails["classTableGroups"][2]["rows"]
//                           [x])
//                         Center(child: Text("$y")),
//                     ])
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
