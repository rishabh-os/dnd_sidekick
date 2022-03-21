import "package:dnd_sidekick/Components/DataLoader.dart";
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookProvider extends ChangeNotifier {
  final List defaultBook = DndData.allSpells;

  List book = DndData.allSpells;
  List sourceFilteredBook = [];
  List sourceIntFilters = [];
  List sourceFilters = [];
  List levelFilteredBook = [];
  List levelFilters = [];
  List<String> spellBookFilter = [
    "AI",
    "EGW",
    "IDRotF",
    "LLK",
    "PHB",
    "TCE",
    "XGE"
  ];

  String sortValue = "Level";
  List<String> sortOptions = ["Spell Name", "Level", "Source Name"];
  double sortAscending = 0;

  List<String> classFilter = [
    "Artificer",
    "Barbarian",
    "Bard",
    "Cleric",
    "Druid",
    "Fighter",
    "Monk",
    "Paladin",
    "Ranger",
    "Rogue",
    "Sorcerer",
    "Warlock",
    "Wizard"
  ];
  List classFilteredBook = [];
  List classIntFilters = [];
  List classFilters = [];

  void setLevelFilter(List levels) {
    levelFilters = levels;
    masterFilter();
  }

  void setSourceFilter(List sources) {
    sourceFilters = [];
    sourceIntFilters = sources;
    sourceIntFilters
        .forEach((element) => sourceFilters.add(spellBookFilter[element]));

    masterFilter();
  }

  void setClassFilter(List classes) {
    classFilters = [];
    classIntFilters = classes;
    classIntFilters
        .forEach((element) => classFilters.add(classFilter[element]));

    masterFilter();
  }

  List filterByCategory(List selectedItems, String category) {
    var filteredBook = [];
    if (selectedItems.isNotEmpty) {
      if (category != "classes") {
        selectedItems.forEach((value) {
          List x = [];
          x = defaultBook
              .where((element) => element[category] == value)
              .toList();

          filteredBook = filteredBook + x;
        });
      } else {
        // ? Do something to sort by classes
      }
      return filteredBook;
    } else {
      return defaultBook;
    }
  }

  void masterFilter() {
    Set s1 = filterByCategory(levelFilters, "level").toSet();
    Set s2 = filterByCategory(sourceFilters, "source").toSet();
    Set s3 = filterByCategory(classFilters, "classes").toSet();
    book = s1.intersection(s2).intersection(s3).toList();
    notifyListeners();
  }

  void resetBook() {
    book = defaultBook;
    notifyListeners();
  }

  void sorting(value) {
    sortValue = value;
    switch (value) {
      case "Spell Name":
        book.sort((a, b) => a["name"].compareTo(b["name"]));
        break;
      case "Level":
        book.sort((a, b) => a["level"].compareTo(b["level"]));
        break;
      case "Source Name":
        book.sort((a, b) => a["source"].compareTo(b["source"]));
        break;
    }

    notifyListeners();
  }

  void changeSortingOrder() {
    sortAscending = sortAscending == 0 ? 0.5 : 0;
    book = List.from(book.reversed);
    notifyListeners();
  }
}

final bookProvider = ChangeNotifierProvider((ref) => BookProvider());
