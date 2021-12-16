import 'package:dnd_sidekick/Components/DataLoader.dart';
import 'package:dnd_sidekick/Sections/Spells/SearchAll.dart';
import 'package:dnd_sidekick/Sections/Spells/SpellListView.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredBook extends ChangeNotifier {
  final List defaultBook = DndData.allSpells;
  List book = DndData.allSpells;
  List sourceFilteredBook = [];
  List sourceIntFilters = [];
  List sourceFilters = [];
  List levelFilteredBook = [];
  List levelFilters = [];
  List<String> spellBookFilter = [
    'AI',
    'EGW',
    'IDRotF',
    'LLK',
    'PHB',
    'TCE',
    'XGE'
  ];

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

  List filterByCategory(List selectedItems, String category, List passedBook) {
    var filteredBook = [];
    if (selectedItems.isNotEmpty) {
      selectedItems.forEach((value) {
        List x =
            passedBook.where((element) => element[category] == value).toList();
        filteredBook = filteredBook + x;
      });
      return filteredBook;
    } else {
      return passedBook;
    }
  }

  void masterFilter() {
    List f1 = filterByCategory(levelFilters, "level", defaultBook);
    List f2 = filterByCategory(sourceFilters, "source", defaultBook);
    Set ef1 = f1.toSet();
    Set ef2 = f2.toSet();
    book = ef1.intersection(ef2).toList();
    notifyListeners();
  }

  void resetBook() {
    book = defaultBook;
    notifyListeners();
  }
}

final bookProvider = ChangeNotifierProvider((ref) => FilteredBook());

class AllSpells extends StatefulWidget {
  AllSpells({Key? key}) : super(key: key);

  @override
  _AllSpellsState createState() => _AllSpellsState();
}

class _AllSpellsState extends State<AllSpells> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final x = ref.watch(bookProvider);
      final y = ref.watch(favouriteProvider);
      y.readFavsFromStorage();
      // x.book.sort((a, b) => a["name"].compareTo(b['name']));
      return Scaffold(
          appBar: AppBar(
            title: Text('All Spells'),
            actions: [
              IconButton(
                  tooltip: "Favorite spells",
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/favSpells');
                  }),
            ],
          ),
          body: buildSpellList(context, x.book),
          resizeToAvoidBottomInset:
              false, //? Prevents the FAB from coming up with the keyboard
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                  tooltip: "Filter spells",
                  child: Icon(Icons.filter_list_outlined),
                  onPressed: () {
                    showFilters(context);
                  }),
              SizedBox(
                width: 10,
                height: 0,
              ),
              SearchAllFAB(),
            ],
          ));
    });
  }

  Future<dynamic> showFilters(BuildContext context) => showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          GroupController sourceFilterController = GroupController(
              isMultipleSelection: true,
              initSelectedItem: ref.read(bookProvider).sourceIntFilters);
          GroupController levelFilterController = GroupController(
              isMultipleSelection: true,
              initSelectedItem: ref.read(bookProvider).levelFilters);
          List<String> spellBookFilter = ref.read(bookProvider).spellBookFilter;
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
                      ref.read(bookProvider).setSourceFilter(selectedSources);
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
                    ref.read(bookProvider).setLevelFilter(selectedLevels);
                  },
                ),
                // Text(
                //   "Class",
                //   style: TextStyle(fontSize: 20),
                // ),
                ElevatedButton(
                  child: Text("Reset".toUpperCase()),
                  onPressed: () {
                    sourceFilterController.deselectAll();
                    levelFilterController.deselectAll();
                    ref.read(bookProvider).sourceIntFilters = [];
                    ref.read(bookProvider).levelFilters = [];
                    ref.read(bookProvider).resetBook();
                  },
                ),
              ],
            ),
          );
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
}
