import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";



class MainScreen extends StatelessWidget {
  const MainScreen(
      {final Key? key,
      this.menuScreenContext,
      this.hideStatus = false})
      : super(key: key);
  final BuildContext? menuScreenContext;
  final bool? hideStatus;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            backgroundColor: Colors.indigo,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings:  RouteSettings(name: "/home"),
                        screen:  MainScreen2(),
                        pageTransitionAnimation:
                            PageTransitionAnimation.scaleRotate,
                      );
                    },
                    child: const Text(
                      "Go to Second Screen ->",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
}

class MainScreen2 extends StatelessWidget {
  const MainScreen2({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen:  MainScreen3());
                },
                child: const Text(
                  "Go to Third Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Go Back to First Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
}

class MainScreen3 extends StatelessWidget {
  const MainScreen3({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Go Back to Second Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
}
