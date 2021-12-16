import 'package:dnd_sidekick/Sections/Spells/SpellDetails.dart';
import 'package:dnd_sidekick/main.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

DraggableScrollbar buildSpellList(BuildContext context, book) {
  ScrollController cont = ScrollController();

  return DraggableScrollbar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    heightScrollThumb: 100,
    scrollThumbBuilder: (
      Color backgroundColor,
      Animation<double> thumbAnimation,
      Animation<double> labelAnimation,
      double height, {
      BoxConstraints? labelConstraints,
      Text? labelText,
    }) {
      return FadeTransition(
        opacity: thumbAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          height: height,
          width: 15,
        ),
      );
    },
    controller: cont,
    child: ListView.builder(
        itemExtent: 80,
        cacheExtent: 20,
        controller: cont,
        itemCount: book.length,
        itemBuilder: (context, index) {
          Map schools = {
            "C": "Conjuration",
            "N": "Necromancy",
            "E": "Evocation",
            "A": "Abjuration",
            "T": "Transmutation"
          };
          // Map componentMap = {"v": "Verbal", "s": "Somatic", "m": "Material"};
          final i = book[index];
          final spellName = i["name"];
          final classes = i["classes"]["fromClassList"] != null
              ? [for (var i in i["classes"]["fromClassList"]) i["name"]]
                  .toSet()
                  .toList() //! Clever AF method to get rid of diplicate Artificers
              : ""; //! The ternary operator is a fix for TCE
          final strClasses =
              classes.toString().replaceAll('[', '').replaceAll(']', '');
          final level = i["level"] == 0 ? "Cantrip" : "Level: ${i["level"]}";
          final source = "Source: ${i["source"]}";
          final spellSchool = schools[i["school"]];
          var materials;
          var components = i["components"].keys.toList();
          final strComponents = components
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .toUpperCase();
          dynamic checkMaterial = (i["components"]['m']);
          switch (checkMaterial.runtimeType) {
            case Null:
              materials = "None";
              break;
            case String:
              materials = checkMaterial;
              break;
            default:
              materials = checkMaterial["text"];
          }
          //! Most of this literally just for one spell Dream
          var castRangeAmount = '';
          String? castRangeType = '';
          if (i["range"]["distance"] != null) {
            castRangeAmount = i["range"]["distance"]["amount"] != null
                ? i["range"]["distance"]["amount"].toString()
                : "";
            castRangeType = i["range"]["distance"]["type"];
          }

          return EachSpell(
              spellName: spellName,
              strClasses: strClasses,
              spellSchool: spellSchool,
              strComponents: strComponents,
              materials: materials,
              i: i,
              castRangeType: castRangeType,
              castRangeAmount: castRangeAmount,
              level: level,
              source: source);
        }),
  );
}

class FavouriteSpellsNotifier extends ChangeNotifier {
  List<String> favSpellNames = [];
  void readFavsFromStorage() async {
    String favKey = "favKey";
    // ? This returns an empty list if there are no favourties
    favSpellNames = SharedPrefs.instance.getStringList(favKey) ?? [];
  }

  void wrtieFavsToStorage() async {
    String favKey = "favKey";
    SharedPrefs.instance.setStringList(favKey, favSpellNames);
  }

  void addFav(spellName) {
    favSpellNames.add(spellName);
    wrtieFavsToStorage();
    notifyListeners();
  }

  void removeFav(spellName) {
    favSpellNames.remove(spellName);
    wrtieFavsToStorage();
    notifyListeners();
  }
}

final favouriteProvider =
    ChangeNotifierProvider((ref) => FavouriteSpellsNotifier());
