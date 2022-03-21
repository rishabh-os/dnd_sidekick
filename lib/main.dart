import "package:dnd_sidekick/Components/DataLoader.dart";
import "package:dnd_sidekick/Sections/Spells/AllSpells.dart";
import "package:dnd_sidekick/Sections/ClassInfo.dart";
import "package:dnd_sidekick/Sections/Classes.dart";
import "package:dnd_sidekick/Sections/Spells/FavouriteSpells.dart";
import "package:dnd_sidekick/Sections/Homepage.dart";
import "package:dnd_sidekick/Components/Themes.dart";
import "package:flutter/material.dart";
import "package:animated_theme_switcher/animated_theme_switcher.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

// ? A class to handle a single instance of SharedPrefs, which is initialised on app start
class SharedPrefs {
  static late final SharedPreferences instance;
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();
}

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    DndData.getAllSpells();
    SharedPrefs.init();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        initTheme: Themes.dark,
        builder: (context, myTheme) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "DnD Database",
              theme: myTheme,
              initialRoute: "/",
              routes: {
                "/": (context) => HomePage(),
                "/classes": (context) => Classes(),
                "/classInfo": (context) => ClassInfo(),
                "/allSpells": (context) => AllSpells(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == "/favSpells") {
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FavouriteSpells(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );
                }
                return null;
              });
        });
  }
}
