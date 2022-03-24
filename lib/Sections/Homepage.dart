import "package:animated_theme_switcher/animated_theme_switcher.dart";
import "package:animations/animations.dart";
import "package:dnd_sidekick/Components/Themes.dart";
import "package:dnd_sidekick/Sections/Spells/AllSpells.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FToast fToast = FToast();
  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.yellow.shade300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_rounded, color: Colors.black),
          SizedBox(
            width: 12.0,
          ),
          Text(
            "Work in Progress!",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(milliseconds: 800),
    );
  }

  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "Home",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  OpenContainer(
                      transitionDuration: Duration(milliseconds: 300),
                      closedBuilder: (_, openContainer) {
                        return ElevatedButton(
                            onPressed: openContainer,
                            child: Text("All Spells"));
                      },
                      openColor: Theme.of(context).colorScheme.secondary,
                      closedElevation: 5.0,
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      closedColor:
                          Theme.of(context).buttonTheme.colorScheme!.primary,
                      openBuilder: (_, closeContainer) {
                        return AllSpells();
                      }),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pushNamed("/allSpells");
                  //     },
                  //     child: Text("Spells TESTING")),
                  ElevatedButton(
                      onPressed: () {
                        _showToast();
                      },
                      child: Text("Classes")),
                  ElevatedButton(
                      onPressed: () {
                        _showToast();
                      },
                      child: Text("Items")),
                  ElevatedButton(
                      onPressed: () => _showToast(), child: Text("Monsters")),
                ]),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: ThemeSwitcher(
          builder: (context) {
            return FloatingActionButton(
                tooltip: "Change theme",
                heroTag: "none",
                child: Icon(Icons.brightness_7_rounded),
                mini: true,
                onPressed: () {
                  ThemeSwitcher.of(context).changeTheme(
                    theme: ThemeModelInheritedNotifier.of(context)
                                .theme
                                .brightness ==
                            Brightness.light
                        ? Themes.dark
                        : Themes.light,
                  );
                });
          },
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                height: 30,
                child: Center(
                    child: Text(
                  // "Made with 💦 \n by Rishabh",
                  "Made by Rishabh",
                  textAlign: TextAlign.center,
                ))),
            elevation: 10),
      ),
    );
  }
}
