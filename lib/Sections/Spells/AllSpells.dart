import 'package:dnd_sidekick/Components/BookProvider.dart';
import 'package:dnd_sidekick/Sections/Spells/Filters.dart';
import "package:dnd_sidekick/Sections/Spells/SearchAll.dart";
import "package:dnd_sidekick/Sections/Spells/SpellListView.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

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
      return Scaffold(
          appBar: AppBar(
            title: Text("All Spells"),
            actions: [
              IconButton(
                  tooltip: "Favorite spells",
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/favSpells");
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
}
