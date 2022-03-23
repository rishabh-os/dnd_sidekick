import "dart:convert";
import "dart:core";
import '../Sections/Spells/included.dart';
import "package:flutter/services.dart";

class DndData {
  static List<String?> classNamesList = [];
  static List<Map> fullClasses = [];
  static List<String> spellBookList = [];
  static List spellBooksFullList = [];
  static List<String> spellBookNames = [
    "Acquisitions Incorporated",
    "Explorer's Guide to Wildemount",
    "Icewind Dale: Rime of the Frostmaiden",
    "Lost Library of Kwalish",
    "Player's Handbook",
    "Tasha's Cauldron of Everything",
    "Xanathar's Guide to Everything",
    // "Included Spells"
  ];

  static Map<String, String> bookFileToBookTitle = {};
  static var manifestMap =
      Future.any([rootBundle.loadString("AssetManifest.json")])
          .then((value) => json.decode(value).keys);

  static Future<List> getFilePaths(contains) async {
    return await manifestMap.then((value) =>
        value.where((String key) => key.contains(contains)).toList());
  }

  static Future getClasses() async {
    List filePaths = await (getFilePaths("class/class"));
    //! Using .forEach messes up the order of the names and .sort() doesn't fix it
    for (int i = 0; i < filePaths.length; i++) {
      final response = await rootBundle.loadString(filePaths[i]);
      Map decoded = json.decode(response) as Map;
      classNamesList.add(decoded["class"][0]["name"]);
      fullClasses.add(decoded);
    }
  }

  static List allSpells = [];
  static List<Spell> allSpells2 = [];
  static getAllSpells() async {
    var path = await getFilePaths("included");

    final res = await rootBundle.loadString(path[0]);
    allSpells = json.decode(res) as List;
    allSpells2 = allSpells.map((i) => Spell.fromJson(i)).toList();
  }
}

extension CapExtension on String {
  String get capitalizeFirstLetter =>
      this.length > 0 ? "${this[0].toUpperCase()}${this.substring(1)}" : "";
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(" +"), " ")
      .split(" ")
      .map((str) => str.capitalizeFirstLetter)
      .join(" ");
}
