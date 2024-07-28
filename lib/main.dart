
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'Airplane/AirplanePage.dart';
import 'CustomerList/CustomerPage.dart';
import 'flight/flight_list_page.dart';
import 'reservation/ReservationPage.dart';


/// The main entry point of the application.
void main() {
  runApp(const MyApp());
}
/// The root widget of the application.
class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  _MyAppState createState() {
    return _MyAppState();
  }
  /// Changes the locale of the app.
  ///
  /// Takes in a [BuildContext] and a [Locale] object. Finds the ancestor state
  /// of type [_MyAppState] and calls the [changeLanguage] method.
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

}
/// The state for the [MyApp] widget.
class _MyAppState extends State<MyApp>
{
  /// The current locale of the app. Default is English (Canada).
  var _locale = Locale("en", "CA"); //default is english from Canada

  /// Changes the language of the app.
  ///
  /// Takes in a [Locale] object and sets the state to the new language.
  void changeLanguage(Locale newLanguage)
  {
    setState(() {
      _locale = newLanguage; //set app to new language, and redraw
    });

  }

  /// Builds the widget tree.
  ///
  /// This widget is the root of your application.
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
/// The home page of the application.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// The title of the home page.
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

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){Navigator.pushNamed(context,"/CustomerPage" );},
              child:const Text("Customer List", style: TextStyle(color: Colors.blue)),
            ),
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
            ElevatedButton(
              onPressed: (){Navigator.pushNamed(context,"/CustomerPage" );},
              child:const Text("Customer List", style: TextStyle(color: Colors.blue)),
            )

          ],
        ),
      ),
    );
  }
}