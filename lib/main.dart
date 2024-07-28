
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'Airplane/AirplanePage.dart';
import 'CustomerList/CustomerPage.dart';
import 'flight/flight_list_page.dart';
import 'reservation/ReservationPage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  _MyAppState createState() {
    return _MyAppState();
  }

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

}

class _MyAppState extends State<MyApp>
{

  var _locale = Locale("en", "CA"); //default is english from Canada

  void changeLanguage(Locale newLanguage)
  {
    setState(() {
      _locale = newLanguage; //set app to new language, and redraw
    });

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      supportedLocales:  const<Locale> [
        Locale("en", "CA"),
        Locale("zh", "CH"),//country doesn't matter in this case
      ] ,

      localizationsDelegates: const[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: _locale, //default is "en", "CA" from above

      title: 'Flutter Demo',

      //routers
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Home Page'),
        '/AirplanePage': (context) { return  AirplanePage(); }, //Same as above =>
        '/FlightPage': (context) { return const FlightPage();},
        '/CustomerPage': (context) { return  CustomerPage(); }, //Same as above =>
        '/ReservationPage': (context) { return  ReservationPage(); },

      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              onPressed: (){Navigator.pushNamed(context,"/AirplanePage" );},
              child:const Text("Airplane List", style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: (){Navigator.pushNamed(context,"/FlightPage" );},
              child:const Text("Flight List", style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: (){Navigator.pushNamed(context,"/ReservationPage" );},
              child:const Text("Reservation List", style: TextStyle(color: Colors.blue)),
            ),

          ],
        ),
      ),
    );
  }
}