import "package:dnd_sidekick/Components/DataLoader.dart";
import 'package:dnd_sidekick/Sections/Spells/included.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookProvider extends ChangeNotifier {
  final List<Spell> defaultBook = DndData.allSpells2;

  List<Spell> book = DndData.allSpells2;
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
    List<Spell> filteredBook = [];
    if (selectedItems.isNotEmpty) {
      selectedItems.forEach((value) {
        List<Spell> x = [];
        x = defaultBook.where((element) {
          switch (category) {
            case "level":
              return element.level == value;
            // break;
            case "source":
              return element.source == value;
            case "classes":
              var fromClassListObjests = element.classes!.fromClassList;
              bool included = false;
              // ? Include subclasses somehow
              fromClassListObjests?.forEach((element) {
                if (element.name == value) {
                  included = true;
                }
              });
              return included;
            default:
              return false;
          }
        }).toList();

        filteredBook = filteredBook + x;
      });

      return filteredBook;
    } else {
      return defaultBook;
    }
  }

  void masterFilter() {
    Set s1 = filterByCategory(levelFilters, "level").toSet();
    Set s2 = filterByCategory(sourceFilters, "source").toSet();
    Set s3 = filterByCategory(classFilters, "classes").toSet();
    book = List<Spell>.from(s1.intersection(s2).intersection(s3).toList());
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
        // book.sort((a, b) => a["name"].compareTo(b["name"]));
        book.sort(((a, b) => (a.name?.compareTo(b.name ?? "") ?? 0)));
        break;
      case "Level":
        book.sort(((a, b) => (a.level?.compareTo(b.level ?? 0) ?? 0)));
        break;
      case "Source Name":
        book.sort(((a, b) => (a.source?.compareTo(b.source ?? "") ?? 0)));
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
