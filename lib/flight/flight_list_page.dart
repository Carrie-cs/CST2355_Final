import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import '../AppLocalizations.dart';

import '../main.dart';
import 'flight.dart';
import 'flight_dao.dart';
import 'flight_database.dart';

/// This is the flights page of the application.
/// This page lists all the flights and provides functionality to add, update, and delete flights.
/// @author: Yao Yi
/// Date: Jul 22, 2024

/// A stateful widget that displays the flight management page.
/// The state of this widget is managed by the `_FlightPageState` class.
class FlightPage extends StatefulWidget {
  /// The constructor for the `FlightPage` widget.
  const FlightPage({super.key});
  /// Override the createState() method
  @override
  State<FlightPage> createState() => FlightPageState();
}

/// The state class for the flight page widget.
class FlightPageState extends State<FlightPage> {
  /// Declare attributes
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  late TextEditingController _controller5;
  late EncryptedSharedPreferences flightPrefs;
  var flightList = <Flight>[];
  late FlightDao flightDao;
  Flight? selectedFlight;
  bool isCreatingFlight = false;

  /// Override initState() method
  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();
    _initEncryptedSharedPreferences();
    _initializeDatabase();
  }

  /// Method to initialize EncryptedSharedPreferences.
  Future<void> _initEncryptedSharedPreferences()  async {
    flightPrefs = EncryptedSharedPreferences();
  }

  /// Method to initialize database and retrieve data from database.
  Future<void> _initializeDatabase() async {
    // Initialize database object.
    final database = await $FloorFlightDatabase.databaseBuilder('flight_database.db').build();
    flightDao = database.flightDao;
    // Retrieve flights from database.
    flightDao.getAllFlight().then((listOfFlight) {
      setState(() {
        flightList.addAll(listOfFlight);
      });
    });
  }

  /// Override dispose() method
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  /// Method to save data to EncryptedSharedPreferences object
  Future<void> _saveFlightToPreferences(Flight flight) async {
    await flightPrefs.setString('Id_${flight.flightId}', flight.flightId);
    await flightPrefs.setString('Dep_${flight.flightId}', flight.departureCity);
    await flightPrefs.setString('Dest_${flight.flightId}', flight.destinationCity);
    await flightPrefs.setString('ETD_${flight.flightId}', flight.departureTime);
    await flightPrefs.setString('ETA_${flight.flightId}', flight.arrivalTime);
  }

  /// This function returns the flight list widget
  Widget _flightList() {
    return Center(
      child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: Text(AppLocalizations.of(context)!.translate('flight_list')!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            ),
            // A header row
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Row(
                children: [
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('list_para1')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                  Expanded(flex:3, child: Text(AppLocalizations.of(context)!.translate('list_para2')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                  Expanded(flex:3, child: Text(AppLocalizations.of(context)!.translate('list_para3')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                  Expanded(flex:3, child: Text(AppLocalizations.of(context)!.translate('list_para4')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('list_para5')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('list_para6')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54))),
                ],
              ),
            ),
            //Use if statement to display information on the page if there's no flight in the list
            if (flightList.isEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Center(
                  child: Text(AppLocalizations.of(context)!.translate('flight_no_data')!,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            // Use Expanded to contain ListView in the Column container, so it can take as much space as possible
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child:ListView.builder(
                    itemCount: flightList.length,
                    itemBuilder: (context, rowNum) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(flex: 2, child: Text("${rowNum + 1}", style: const TextStyle(fontSize: 15.0))),
                              Expanded(flex: 3, child: Text(flightList[rowNum].flightId, style: const TextStyle(fontSize: 15.0))),
                              Expanded(flex: 3, child: Text(flightList[rowNum].departureCity, style: const TextStyle(fontSize: 15.0))),
                              Expanded(flex: 3, child: Text(flightList[rowNum].destinationCity, style: const TextStyle(fontSize: 15.0))),
                              Expanded(flex: 2, child: Text(flightList[rowNum].departureTime, style: const TextStyle(fontSize: 15.0))),
                              Expanded(flex: 2, child: Text(flightList[rowNum].arrivalTime, style: const TextStyle(fontSize: 15.0))),
                            ],
                          ),
                          onTap: () {
                            selectedFlight = flightList[rowNum];
                            setState(() {
                              _detailsPage();
                            });
                          },
                        ),
                      );
                    },
                  )),
            ),
            // Button to display the flight creation page for users to enter new flight details
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  _controller1.clear();
                  _controller2.clear();
                  _controller3.clear();
                  _controller4.clear();
                  _controller5.clear();
                  setState(() {
                    isCreatingFlight = true;
                  });
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.translate('flight_add')!, style: TextStyle(fontSize: 16)),
              ),
            ),
          ]),
    );
  }

  /// This function returns the createPage widget
  Widget _createPage() {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
            child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text(AppLocalizations.of(context)!.translate('flight_add_title')!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: TextField(
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate('input_prompt')!,
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate('input_flight_id')!,
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: TextField(
                          controller: _controller2,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate('input_prompt')!,
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate('input_departure')!,
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: TextField(
                          controller: _controller3,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate('input_prompt')!,
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate('input_destination')!,
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: TextField(
                          controller: _controller4,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate('input_prompt')!,
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate('input_departure_time')!,
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: TextField(
                          controller: _controller5,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate('input_prompt')!,
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.translate('input_arrival_time')!,
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(150, 50),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                if (_controller1.value.text != "" && _controller2.value.text != "" && _controller3.value.text != "" && _controller4.value.text != "" && _controller5.value.text != "") {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                          title: Text(AppLocalizations.of(context)!.translate('flight_confirm')!),
                                          content: Text(AppLocalizations.of(context)!.translate('flight_add_confirm_message')!, style: const TextStyle(fontSize: 18)),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: (){
                                                  setState(() {
                                                    var newFlightId = _controller1.value.text;
                                                    var newDepartureCity = _controller2.value.text;
                                                    var newDestinationCity = _controller3.value.text;
                                                    var newDepartureTime = _controller4.value.text;
                                                    var newArrivalTime = _controller5.value.text;
                                                    var flight = Flight(newFlightId, newDepartureCity, newDestinationCity, newDepartureTime, newArrivalTime);

                                                    // Save new flight to database
                                                    flightDao.addFlight(flight);

                                                    // Save new flight to EncryptedSharedPreferences
                                                    _saveFlightToPreferences(flight);

                                                    // Save new flight to ListView
                                                    flightList.add(flight);

                                                    _controller1.clear();
                                                    _controller2.clear();
                                                    _controller3.clear();
                                                    _controller4.clear();
                                                    _controller5.clear();

                                                    isCreatingFlight = false;
                                                  });
                                                  // Show SnackBar to inform user the new flight was added successfully
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(AppLocalizations.of(context)!.translate('flight_add_success')!),
                                                        duration: const Duration(seconds: 4),
                                                      ));
                                                  Navigator.pop(context);
                                                },
                                                child: Text(AppLocalizations.of(context)!.translate('flight_yes')!, style: const TextStyle(fontSize: 16))
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isCreatingFlight = false;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text(AppLocalizations.of(context)!.translate('flight_no')!, style: const TextStyle(fontSize: 16))
                                            )
                                          ]
                                      )
                                  );}
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(AppLocalizations.of(context)!.translate('flight_add_warning')!),
                                        duration: const Duration(seconds: 10),
                                        action: SnackBarAction(label: "OK", onPressed: () {})
                                    ),
                                  );
                                }
                              },
                              child: Text(AppLocalizations.of(context)!.translate('flight_add_submit')!, style: const TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(width: 20),
                            FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(150, 50),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isCreatingFlight = false;
                                  });
                                },
                                child: Text(AppLocalizations.of(context)!.translate('flight_add_cancel')!, style: TextStyle(fontSize: 16))
                            ),
                          ]
                      )
                  )
                ]
            )
        )
    );
  }

  /// This function returns the flight detailsPage widget
  Widget _detailsPage() {
    if (selectedFlight != null) {
      // Set the controller text values
      _controller1.text = selectedFlight!.flightId;
      _controller2.text = selectedFlight!.departureCity;
      _controller3.text = selectedFlight!.destinationCity;
      _controller4.text = selectedFlight!.departureTime;
      _controller5.text = selectedFlight!.arrivalTime;

      return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.translate('flight_detail_title')!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.translate('flight_detail_id')!, style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextField(
                              controller: _controller1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.translate('flight_detail_departure')!, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextField(
                              controller: _controller2,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.translate('flight_detail_destination')!, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextField(
                              controller: _controller3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.translate('flight_detail_etd')!, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextField(
                              controller: _controller4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalizations.of(context)!.translate('flight_detail_eta')!, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextField(
                              controller: _controller5,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // The update button to update the information of the selected flight
                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            // Store the origin values in text fields
                            String originalFlightId = selectedFlight!.flightId;
                            String originalDepartureCity = selectedFlight!.departureCity;
                            String originalDestinationCity = selectedFlight!.destinationCity;
                            String originalDepartureTime = selectedFlight!.departureTime;
                            String originalArrivalTime = selectedFlight!.arrivalTime;

                            // Store the updated values in text fields
                            String newFlightId = _controller1.text;
                            String newDepartureCity = _controller2.text;
                            String newDestinationCity = _controller3.text;
                            String newDepartureTime = _controller4.text;
                            String newArrivalTime = _controller5.text;

                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.translate('flight_confirm')!),
                                    content: Text(AppLocalizations.of(context)!.translate('flight_update_confirm_message')!, style: TextStyle(fontSize: 18)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(AppLocalizations.of(context)!.translate('flight_yes')!, style: TextStyle(fontSize: 16)),
                                        onPressed: (){
                                          setState(() {
                                            // Update the selected flight attributes with the new values
                                            selectedFlight!.flightId = newFlightId;
                                            selectedFlight!.departureCity = newDepartureCity;
                                            selectedFlight!.destinationCity = newDestinationCity;
                                            selectedFlight!.departureTime = newDepartureTime;
                                            selectedFlight!.arrivalTime = newArrivalTime;

                                            // Update the flight in the database
                                            flightDao.updateFlight(selectedFlight!);

                                            // Update the flight in the EncryptedSharedPreferences
                                            _saveFlightToPreferences(selectedFlight!);

                                            // Update the flight in the ListView
                                            int index = flightList.indexWhere((flight) => flight.flightId == selectedFlight!.flightId);
                                            if (index != -1) {
                                              flightList[index] = selectedFlight!;
                                            }
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(AppLocalizations.of(context)!.translate('flight_update_success')!),
                                              duration: const Duration(seconds: 4),),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(AppLocalizations.of(context)!.translate('flight_no')!, style: const TextStyle(fontSize: 16)),
                                        onPressed: (){
                                          setState(() {
                                            // Display the origin values in text fields
                                            _controller1.text = originalFlightId;
                                            _controller2.text = originalDepartureCity;
                                            _controller3.text = originalDestinationCity;
                                            _controller4.text = originalDepartureTime;
                                            _controller5.text = originalArrivalTime;
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]
                                )
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.translate('flight_update')!, style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 20),
                        // The delete button to remove the selected flight
                        FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(150, 50),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.translate('flight_confirm')!),
                                      content: Text(AppLocalizations.of(context)!.translate('flight_delete_confirm_message')!, style: const TextStyle(fontSize: 18)),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.translate('flight_yes')!, style: const TextStyle(fontSize: 16)),
                                          onPressed: (){
                                            setState(() {
                                              // Remove the selected flight from database
                                              flightDao.deleteFlight(selectedFlight!);

                                              // Remove the selected flight from EncryptedSharedPreferences
                                              flightPrefs.remove('Id_${selectedFlight!.flightId}');
                                              flightPrefs.remove('Dep_${selectedFlight!.flightId}');
                                              flightPrefs.remove('Dest_${selectedFlight!.flightId}');
                                              flightPrefs.remove('ETD_${selectedFlight!.flightId}');
                                              flightPrefs.remove('ETA_${selectedFlight!.flightId}');

                                              // Remove the selected flight from ListView
                                              flightList.removeWhere((flight) => flight.flightId == selectedFlight!.flightId);
                                              // Reset the selectedFlight to null
                                              selectedFlight = null;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(AppLocalizations.of(context)!.translate('flight_delete_success')!),
                                                duration: const Duration(seconds: 4),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                            child: Text(AppLocalizations.of(context)!.translate('flight_no')!, style: const TextStyle(fontSize: 16)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }
                                        )
                                      ]
                                  )
                              );},
                            child: Text(AppLocalizations.of(context)!.translate('flight_delete')!, style: const TextStyle(fontSize: 16))
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    } else {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.translate('flight_view_message')!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }
  }

  /// Method to display different layouts depending on the screen size
  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // If user click on the 'Add Flight' button, the create page will appear
    if (isCreatingFlight) {
      return _createPage();
    }
    // This is for the landscape model, flight list on the left side, details on the right side
    if ((width > height) && (width > 720)) {
      return Row(children:[
        Expanded(flex:5, child: _flightList()),
        Expanded(flex:4, child: _detailsPage())
      ]);
    }
    // This applies to portrait mode: display the details page once the user selects a flight from the list.
    else {
      if(selectedFlight == null) {
        return _flightList();
      }
      else {
        return _detailsPage();
      }
    }
  }

  /// Override build() method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            tooltip: AppLocalizations.of(context)!.translate('flight_arrow_button_tip')!,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // Button to switch to English
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("en", "CA") ); }, child:Text("EN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ))),
            // Button to switch to Chinese
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("zh", "CH") );  }, child:Text("中文", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ))),
            // Button to back to flight list
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child:
                TextButton(onPressed: () {
                  setState(() {
                    selectedFlight = null;
                  });
                },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context)!.translate('flight_back_button')!))
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.translate('flight_help_title')!),
                        content: Text(value),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.translate('flight_help_confirm')!, style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      );
                    },
                  );
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: AppLocalizations.of(context)!.translate('flight_how_add')!,
                      child: Text(AppLocalizations.of(context)!.translate('flight_how_add_title')!, style: const TextStyle(fontSize: 16)),
                    ),
                    PopupMenuItem<String>(
                      value: AppLocalizations.of(context)!.translate('flight_how_view')!,
                      child: Text(AppLocalizations.of(context)!.translate('flight_how_view_title')!, style: const TextStyle(fontSize: 16)),
                    ),
                    PopupMenuItem<String>(
                      value: AppLocalizations.of(context)!.translate('flight_how_update')!,
                      child: Text(AppLocalizations.of(context)!.translate('flight_how_update_title')!, style: const TextStyle(fontSize: 16)),
                    ),
                    PopupMenuItem<String>(
                      value: AppLocalizations.of(context)!.translate('flight_how_delete')!,
                      child: Text(AppLocalizations.of(context)!.translate('flight_how_delete_title')!, style: const TextStyle(fontSize: 16)),
                    ),
                  ];
                },
                child: Text(AppLocalizations.of(context)!.translate('flight_help_button')!, style: const TextStyle(fontSize: 16, color: Colors.white),),
              ),
            ),
          ],
          backgroundColor: Colors.black87,
          title: Text(AppLocalizations.of(context)!.translate('flight_page_title')!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: responsiveLayout()
    );
  }

}