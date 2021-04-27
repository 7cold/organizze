import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:layout/layout.dart';
import 'package:organizze/ui/home/home_ui.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setWindowMinSize(const Size(1257, 650));
  setWindowMaxSize(Size.infinite);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetMaterialApp(
        checkerboardOffscreenLayers: true,
        //debugShowMaterialGrid: true,
        //showPerformanceOverlay: true,
        //showSemanticsDebugger: true,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('es', ''), // Spanish, no country code
        ],
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.size,
        transitionDuration: Duration(milliseconds: 150),
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeUi(),
      ),
    );
  }
}
