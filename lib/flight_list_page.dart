import 'package:flutter/material.dart';

import 'flight.dart';
import 'flight_dao.dart';
import 'flight_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flights'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;
  late TextEditingController _controller5;
  var flightList = <Flight>[];
  late FlightDao flightDao;
  Flight? selectedFlight;
  bool isCreatingFlight = false;


  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Initialize database object
    final database = await $FloorFlightDatabase.databaseBuilder('flight_database.db').build();
    flightDao = database.flightDao;
    // Retrieve flights from database
    flightDao.getAllFlight().then((listOfFlight) {
      setState(() {
        flightList.addAll(listOfFlight);
      });
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  // This function returns the flight list widget
  Widget _flightList() {
    return Center(
      child: Column(
          children: [
            // A header row
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: const Row(
                children: [
                  Expanded(flex:2, child: Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Expanded(flex:3, child: Text('FlightID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Expanded(flex:4, child: Text('Departure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Expanded(flex:4, child: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Expanded(flex:3, child: Text('Dep.Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Expanded(flex:3, child: Text('Arr.Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                ],
              ),
            ),
            //Use if statement to display information on the page if there's no flight in the list
            if (flightList.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Center(
                  child: Text(
                    "There are no flights in the list, you can start with adding a new flight",
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
                    return GestureDetector(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(flex:2, child: Text("$rowNum", style: const TextStyle(fontSize: 15.0))),
                            Expanded(flex:3, child: Text(flightList[rowNum].flightId, style: const TextStyle(fontSize: 15.0))),
                            Expanded(flex:4, child: Text(flightList[rowNum].departureCity, style: const TextStyle(fontSize: 15.0))),
                            Expanded(flex:4, child: Text(flightList[rowNum].destinationCity, style: const TextStyle(fontSize: 15.0))),
                            Expanded(flex:3, child: Text(flightList[rowNum].departureTime, style: const TextStyle(fontSize: 15.0))),
                            Expanded(flex:3, child: Text(flightList[rowNum].arrivalTime, style: const TextStyle(fontSize: 15.0))),
                          ]),
                      onTap: (){
                        selectedFlight = flightList[rowNum];
                        setState(() {
                          _detailsPage();
                        });
                      },
                    );
                  },
                )),
            ),
            // Button to display the flight creation page for users to enter new flight details
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child:
                FilledButton(
                    child: const Text("Add Flight"),
                    onPressed: () {
                      _controller1.clear();
                      _controller2.clear();
                      _controller3.clear();
                      _controller4.clear();
                      _controller5.clear();
                      setState(() {
                        isCreatingFlight = true;
                      });
                    }
                ),
            )
          ]),
    );
  }

  // This function returns the createPage widget
  Widget _createPage() {
    return Center(
      child: Column(
        children: [
        // Text fields for users to enter flight information
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child:TextField(
              controller: _controller1,
              decoration: const InputDecoration(
                hintText: "Type here",
                border: OutlineInputBorder(),
                labelText: "Enter the flight id",
              )
            )
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(
                    hintText: "Type here",
                    border: OutlineInputBorder(),
                    labelText: "Enter the departure city",
                  )
              )
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:TextField(
                  controller: _controller3,
                  decoration: const InputDecoration(
                    hintText: "Type here",
                    border: OutlineInputBorder(),
                    labelText: "Enter the destination city",
                  )
              )
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:TextField(
                  controller: _controller4,
                  decoration: const InputDecoration(
                    hintText: "Type here",
                    border: OutlineInputBorder(),
                    labelText: "Enter the departure time",
                  )
              )
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:TextField(
                  controller: _controller5,
                  decoration: const InputDecoration(
                    hintText: "Type here",
                    border: OutlineInputBorder(),
                    labelText: "Enter the arrival time",
                  )
              )
          ),
          // Button to add flights to the database
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 80, 40, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      if(_controller1.value.text != "" && _controller2.value.text != "" && _controller3.value.text != "" && _controller4.value.text != "" && _controller5.value.text != "") {
                        setState(() {
                          // Get the user input for each attribute and assign them to variables
                          var newFlightId = _controller1.value.text;
                          var newDepartureCity = _controller2.value.text;
                          var newDestinationCity = _controller3.value.text;
                          var newDepartureTime = _controller4.value.text;
                          var newArrivalTime = _controller5.value.text;
                          // Create an object of type Flight
                          var flight = Flight(newFlightId, newDepartureCity, newDestinationCity, newDepartureTime, newArrivalTime);
                          // Add the new flight to ListView
                          flightList.add(flight);
                          // Add the new flight to database
                          flightDao.addFlight(flight);

                          _controller1.clear();
                          _controller2.clear();
                          _controller3.clear();
                          _controller4.clear();
                          _controller5.clear();

                          isCreatingFlight = false;
                        });
                      }
                      else {
                        var snackBar = SnackBar(
                            content: const Text("Please fill in all fields!"),
                            duration: const Duration(seconds: 10),
                            action: SnackBarAction(label: "OK", onPressed: () {
                            })
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    ),
                FilledButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      setState(() {
                        isCreatingFlight = false; // Return to flights list
                      });
                    },
                )
              ]
            )
          )
        ]
      )
    );
  }

  // This function returns the flight detailsPage widget
  Widget _detailsPage() {
    if(selectedFlight != null) {
      // Set the controller text values
      _controller1.text = selectedFlight!.flightId;
      _controller2.text = selectedFlight!.departureCity;
      _controller3.text = selectedFlight!.destinationCity;
      _controller4.text = selectedFlight!.departureTime;
      _controller5.text = selectedFlight!.arrivalTime;

      return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Center(
                    child: Text(
                      "Details of the Flight",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Flight ID"),
                        Flexible(//To contain the text label and TextField in the same row
                          child: TextField(
                            controller: _controller1,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]
                  ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Departure City"),
                        Flexible(//To contain the text label and TextField in the same row
                          child: TextField(
                            controller: _controller2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]
                  ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Destination City"),
                        Flexible(//To contain the text label and TextField in the same row
                          child: TextField(
                            controller: _controller3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]
                  ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Departure Time"),
                        Flexible(//To contain the text label and TextField in the same row
                          child: TextField(
                            controller: _controller4,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]
                  ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Arrival Time"),
                        Flexible(//To contain the text label and TextField in the same row
                          child: TextField(
                            controller: _controller5,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]
                  ),),

                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 80, 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // The update button to update the information of the selected flight
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            // Update the information of the existing flight
                          });
                        },
                        child: const Text("Update Flight"),
                      ),
                      // The delete button to remove the selected flight
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            // Remove the selected flight from database
                            flightDao.deleteFlight(selectedFlight!);
                            // Remove the selected flight from ListView
                            flightList.removeWhere((flight) => flight.flightId == selectedFlight!.flightId);
                            // Reset the selectedFlight to null:
                            // so if it is in landscape model, the right side display the text "Select an item...",
                            // if it is in portrait model, the screen switch back to to-do list page
                            selectedFlight = null;
                          });
                        },
                        child: const Text("Delete Flight"),
                      ),
                    ],
                  ),
                ),
              ]
          )
      );
    }
    else {
      return const Center(
        child: Text(
          "Select a flight from the list to view the details",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }

  // Show different layouts depending on the screen size
  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // If user click on the 'Add Flight' button, the create page will appear
    if (isCreatingFlight) {
      return _createPage();
    } else if ((width > height) && (width > 720)) {
      // This is for the landscape model, flight list on the left side, details on the right side
      return Row(children:[
        Expanded(child: _flightList()),
        Expanded(child: _detailsPage())
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child:
                OutlinedButton(onPressed: () {
                  setState(() {
                    selectedFlight = null;
                  });
                }, child: const Text("Back"))
            )
          ],
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: responsiveLayout()
    );
  }

}