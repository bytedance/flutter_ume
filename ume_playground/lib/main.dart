import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_ume/core/plugin_manager.dart';

import 'homepage/homepage.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';

import 'homepage/playground.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';

void main() {
  PluginManager.instance.registerAll([
    WidgetDetailInspector(),
    WidgetInfoInspector(),
    ColorPicker(),
    AlignRuler(),
    TouchIndicator(),
    ShowCode(),
  ]);
  runApp(const UMEWidget(child: PlaygroundApp()));
}

final GlobalKey<NavigatorState> nKey = GlobalKey<NavigatorState>();

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: nKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // home: const HomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/homepage',
      routes: {
        '/homepage': (ctx) => HomePage(title: 'title'),
        // '/playground': (ctx) =>
        //     PlaygroundPage(title: 'title', message: 'message'),
      },
      navigatorObservers: [RouteObserver()],
      // onGenerateInitialRoutes: (initialRouteName) {
      //   return
      // },
      // onGenerateRoute: (routeSettings) {
      //   debugPrint(routeSettings.name);
      //   if (routeSettings.name == '/playground') {
      //     // final args = routeSettings.arguments as Map<String, dynamic>;

      //     // Then, extract the required data from
      //     // the arguments and pass the data to the
      //     // correct screen.
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return PlaygroundPage(
      //           title: '', //args['title'],
      //           message: '', //args['message'],
      //         );
      //       },
      //     );
      //   } else if (routeSettings.name == '/') {
      //     // final args = routeSettings.arguments as Map<String, dynamic>;

      //     // Then, extract the required data from
      //     // the arguments and pass the data to the
      //     // correct screen.
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return HomePage(title: '' //args['title'],
      //             );
      //       },
      //     );
      //   }
      //   assert(false, 'Need to implement ${routeSettings.name}');
      //   return null;
      // },
    );
  }
}

class RouteObserver extends NavigatorObserver {
  @override
  void didRemove(Route route, Route? previousRoute) {
    print(route.settings.name! + (previousRoute?.settings.name ?? ''));
    super.didRemove(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // if (route.settings.name == '/homepage' &&
    //     (previousRoute?.settings.name ?? '') == '/playground') {
    //   nKey.currentState?.pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (ctx) => const HomePage(title: 'title')),
    //       (route) => false);
    // }
    // if (route.settings.name == '/playground' &&
    //     (previousRoute?.settings.name ?? '') == '/homepage') {
    //   nKey.currentState?.pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (ctx) => const PlaygroundPage(
    //                 title: 'title',
    //                 message: 'message',
    //               )),
    //       (route) => false);
    // }
    // debugPrint('');
    // print(route.settings.name! + (previousRoute?.settings.name ?? ''));
    super.didPush(route, previousRoute);
  }
}
