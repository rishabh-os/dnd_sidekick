import "dart:collection";
import "package:dnd_sidekick/Sections/Spells/SpellListView.dart";
import "package:dnd_sidekick/Components/DataLoader.dart";
import 'package:dnd_sidekick/Sections/Spells/included.dart';
import "package:flutter/material.dart";
import "package:animations/animations.dart";

class SearchAllFAB extends StatelessWidget {
  const SearchAllFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: Duration(milliseconds: 300),
        closedBuilder: (_, openContainer) {
          return FloatingActionButton(
            tooltip: "Search spells",
            heroTag: "search",
            elevation: 5.0,
            onPressed: openContainer,
            child: Icon(Icons.search),
          );
        },
        openColor: Theme.of(context).colorScheme.secondary,
        closedElevation: 5.0,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
        closedColor: Theme.of(context).colorScheme.secondary,
        openBuilder: (_, closeContainer) {
          return SearchAll();
        });
  }
}

class SearchAll extends StatefulWidget {
  SearchAll({Key? key}) : super(key: key);

  @override
  _SearchAllState createState() => _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
  var results;
  List<Spell> book = DndData.allSpells2;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: TextField(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              isDense: true,
              hintText: "Search spell by name",
              suffixIcon: IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: () => controller.clear(),
              )),
          textCapitalization: TextCapitalization.words,
          onSubmitted: search,
        ),
      ),
      body: Container(
          child:
              results == null ? Container() : buildSpellList(context, results)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_downward_sharp),
      ),
    );
  }

  void search(search) {
    if (search.isNotEmpty) {
      List<Spell> temp = [];
      book.forEach((element) {
        if (element.name!.toLowerCase().contains(search.toLowerCase())) {
          temp.add(element);
        }
      });
      setState(() {
        results = temp;
      });
    } else {
      results = null;
    }
  }
}
