
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
        backgroundColor: Colors.black87,
        title: Text(AppLocalizations.of(context)!.translate('appbar_title')!,
          style: const TextStyle(fontSize:26,color: Colors.white, fontWeight: FontWeight.bold),
        ),
          actions: [
          // Button to switch to English
          TextButton(onPressed: () {MyApp.setLocale(context, Locale("en", "CA") ); }, child:Text("EN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ))),
          // Button to switch to Chinese
          TextButton(onPressed: () {MyApp.setLocale(context, Locale("zh", "CH") );  }, child:Text("中文", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ))),
          ]
      ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.translate('homepage_title')!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier New',
                              shadows: [
                                Shadow(
                                  blurRadius: 25.0,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(AppLocalizations.of(context)!.translate('homepage_para1')!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black.withOpacity(1),
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.translate('homepage_para2')!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black.withOpacity(1),
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.translate('homepage_para3')!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black.withOpacity(1),
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(AppLocalizations.of(context)!.translate('homepage_para4')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.black.withOpacity(1),
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/CustomerPage");
                            },
                            child: Text(AppLocalizations.of(context)!.translate('homepage_button_customer')!,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/AirplanePage");
                            },
                            child: Text(AppLocalizations.of(context)!.translate('homepage_button_airline')!,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/FlightPage");
                            },
                            child: Text(AppLocalizations.of(context)!.translate('homepage_button_flight')!,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/ReservationPage");
                            },
                            child: Text(AppLocalizations.of(context)!.translate('homepage_button_reservation')!,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}