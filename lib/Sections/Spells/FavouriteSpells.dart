import 'package:dnd_sidekick/Components/BookProvider.dart';
import "package:dnd_sidekick/Sections/Spells/SpellListView.dart";
import 'package:dnd_sidekick/Sections/Spells/included.dart';
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class FavouriteSpells extends StatefulWidget {
  FavouriteSpells({Key? key}) : super(key: key);

  @override
  _FavouriteSpellsState createState() => _FavouriteSpellsState();
}

class _FavouriteSpellsState extends State<FavouriteSpells> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final x = ref.watch(favouriteProvider);
      List<Spell> favBook = ref
          .read(bookProvider)
          .defaultBook
          .where((element) => x.favSpellNames.contains(element.name))
          .toList();
      return Scaffold(
          resizeToAvoidBottomInset:
              false, //? Prevents the FAB from coming up with the keyboard
          appBar: AppBar(
            title: Text("Favourite Spells"),
            backgroundColor: Colors.pink,
          ),
          body: buildSpellList(context, favBook));
    });
  }
}
