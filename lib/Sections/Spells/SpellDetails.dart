import "dart:io";
import "package:dnd_sidekick/Sections/Spells/SpellListView.dart";
import "package:flutter/material.dart";
import "package:dnd_sidekick/Components/DataLoader.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:screenshot/screenshot.dart";
import "dart:typed_data";
import "package:path_provider/path_provider.dart";
import 'package:share_plus/share_plus.dart';

class EachSpell extends StatefulWidget {
  const EachSpell({
    Key? key,
    required this.spellName,
    required this.classes,
    required this.spellSchool,
    required this.strComponents,
    required this.materials,
    required this.i,
    required this.castRangeType,
    required this.castRangeAmount,
    required this.level,
    required this.source,
  }) : super(key: key);

  final String spellName;
  final List classes;
  final spellSchool;
  final String strComponents;
  final materials;
  final i;
  final String? castRangeType;
  final String castRangeAmount;
  final String level;
  final String source;

  @override
  _EachSpellState createState() => _EachSpellState();
}

class _EachSpellState extends State<EachSpell> {
  ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => {spellDetails(context)},
          child: ListTile(
            title: Text("${widget.i["name"]}"),
            trailing: Consumer(builder: (context, ref, child) {
              final x = ref.watch(favouriteProvider);
              Widget notFavIcon =
                  Icon(Icons.star_outline_rounded, key: Key("notfav"));
              Widget favIcon = Icon(
                Icons.star_rounded,
                key: Key("fav"),
                color: Colors.yellow,
              );
              Widget isFav = x.favSpellNames.contains(widget.i["name"])
                  ? favIcon
                  : notFavIcon;
              return IconButton(
                splashRadius: 20,
                onPressed: () {
                  setState(() {
                    if (x.favSpellNames.contains(widget.i["name"])) {
                      x.removeFav(widget.i["name"]);
                      isFav = notFavIcon;
                    } else {
                      x.addFav(widget.i["name"]);
                      isFav = favIcon;
                    }
                  });
                },
                icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: isFav),
              );
            }),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("${widget.level}"), Text("${widget.source}")],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> spellDetails(BuildContext context) {
    ScreenshotController sc = ScreenshotController();
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        Map rowDisplay = {
          "Name": widget.spellName,
          "Classes":
              widget.classes.toString().replaceAll("[", "").replaceAll("]", ""),
          "Materials": widget.materials.toString().capitalizeFirstLetter,
          "Description": widget.i["entries"][0]
        };
        Map gridDisplay = {
          "Level": widget.level.replaceFirst("Level: ", ""),
          "School": widget.spellSchool,
          "Components": widget.strComponents,
          "Cast Time": widget.i["time"][0]["number"].toString() +
              " " +
              widget.i["time"][0]["unit"],
          "Cast Type":
              widget.i["range"]["type"].toString().capitalizeFirstofEach,
          "Range": widget.castRangeAmount +
              " " +
              widget.castRangeType.toString().capitalizeFirstofEach,
        };

        return Screenshot(
          controller: sc,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // controller: scroll,
            // shrinkWrap: true,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.spellName}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 2, color: Theme.of(context).splashColor)),
                  child: Column(children: [
                    Center(
                        child: Text(
                      "${rowDisplay.keys.toList()[1]}",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    )),
                    Center(
                      child: Text(
                        "${rowDisplay.values.toList()[1]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                ),
              ),
              Wrap(
                spacing: 4, //vertical spacing
                runSpacing: 4, //horizontal spacing
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  for (var i = 0; i < gridDisplay.length; i++)
                    Container(
                      width: 135,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 2, color: Theme.of(context).splashColor)),
                      child: Column(children: [
                        Center(
                            child: Text(
                          "${gridDisplay.keys.toList()[i]}",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        )),
                        Center(
                          child: Text(
                            "${gridDisplay.values.toList()[i]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ]),
                    ),
                ],
              ),
              ListTile(
                title: Text("${rowDisplay.keys.toList()[2]}"),
                subtitle: Text("${rowDisplay.values.toList()[2]}"),
              ),
              ListTile(
                title: Text("${rowDisplay.keys.toList()[3]}"),
                subtitle: Text("${rowDisplay.values.toList()[3]}"),
              ),
              IconButton(
                  splashRadius: 20,
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    await shareSpell(sc);
                  },
                  icon: Icon(Icons.share))
            ],
          ),
        );
      },
    );
  }

  Future<Null> shareSpell(ScreenshotController sc) async {
    return await sc.capture().then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File("${directory.path}/image.png").create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
  }
}
