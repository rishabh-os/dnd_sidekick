import 'package:dnd_sidekick/Components/BookProvider.dart';
import "package:flutter/material.dart";
import "package:checkbox_grouped/checkbox_grouped.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

Future<dynamic> showFilters(BuildContext context) => showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    context: context,
    builder: (context) {
      return Consumer(builder: (context, ref, _) {
        final prov = ref.read(bookProvider);
        GroupController sourceFilterController = GroupController(
            isMultipleSelection: true, initSelectedItem: prov.sourceIntFilters);
        GroupController levelFilterController = GroupController(
            isMultipleSelection: true, initSelectedItem: prov.levelFilters);
        GroupController classFilterController = GroupController(
            isMultipleSelection: true, initSelectedItem: prov.classIntFilters);
        List<String> spellBookFilter = prov.spellBookFilter;
        List<String> classFilter = prov.classFilter;
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Source",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SimpleGroupedChips(
                    chipGroupStyle: chipGroupStyle(context),
                    values: [
                      for (var i = 0; i < spellBookFilter.length; i++) i
                    ],
                    itemTitle: spellBookFilter,
                    controller: sourceFilterController,
                    onItemSelected: (selectedSources) {
                      prov.setSourceFilter(selectedSources);
                    }),
                Text(
                  "Level",
                  style: TextStyle(fontSize: 20),
                ),
                SimpleGroupedChips<int>(
                  chipGroupStyle: chipGroupStyle(context),
                  controller: levelFilterController,
                  values: [for (var i = 0; i < 10; i++) i],
                  itemTitle: [
                    "Cantrip",
                    for (var i = 1; i < 10; i++) "Level $i"
                  ],
                  onItemSelected: (selectedLevels) {
                    prov.setLevelFilter(selectedLevels);
                  },
                ),
                Text(
                  "Class",
                  style: TextStyle(fontSize: 20),
                ),
                SimpleGroupedChips(
                    chipGroupStyle: chipGroupStyle(context),
                    values: [for (var i = 0; i < classFilter.length; i++) i],
                    itemTitle: classFilter,
                    controller: classFilterController,
                    onItemSelected: (selectedClasses) {
                      prov.setClassFilter(selectedClasses);
                    }),
                Text(
                  "Sort By",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          value: prov.sortValue,
                          onChanged: (String? newValue) {
                            bottomSheetState(() {
                              prov.sorting(newValue);
                            });
                          },
                          items: prov.sortOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          bottomSheetState(() {
                            prov.changeSortingOrder();
                          });
                        },
                        icon: AnimatedRotation(
                          curve: Curves.elasticOut,
                          turns: prov.sortAscending,
                          duration: const Duration(milliseconds: 800),
                          child: Icon(Icons.arrow_upward),
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text("Reset".toUpperCase()),
                  onPressed: () {
                    sourceFilterController.deselectAll();
                    levelFilterController.deselectAll();
                    prov.sourceIntFilters = [];
                    prov.levelFilters = [];
                    prov.classIntFilters = [];
                    prov.resetBook();
                  },
                ),
              ],
            ),
          );
        });
      });
    });

ChipGroupStyle chipGroupStyle(BuildContext context) {
  return ChipGroupStyle.minimize(
      selectedIcon: null,
      selectedColorItem: Theme.of(context).colorScheme.secondary,
      // backgroundColorItem: Theme.of(context).chipTheme.backgroundColor,
      textColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      selectedTextColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white);
}
