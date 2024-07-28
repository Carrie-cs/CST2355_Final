
import 'package:cst2335final/CustomerList/CustomerDAO.dart';
import 'package:cst2335final/CustomerList/Customers.dart';
import 'package:cst2335final/CustomerList/CustomersDatabase.dart';
import 'package:cst2335final/flight/flight.dart';
import 'package:cst2335final/flight/flight_dao.dart';
import 'package:cst2335final/flight/flight_database.dart';
import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:cst2335final/reservation/ReservationDao.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ReservationDatabase.dart';
import 'ReservationRepository.dart';
/// This is the reservation page of the application.
/// This page lists all the reservation and provides functionality to add, view detail reservation.
/// @author: Hongxiu Guo
/// Date: Jul 27, 2024

/// A stateful widget that displays the reservation management page.
/// The state of this widget is managed by the `_ReservationPageState` class.
class ReservationPage extends StatefulWidget { // stateful means has variables
  @override
  State<ReservationPage> createState() => ReservationPageState();
}
/// The state class for the reservation page widget.
class ReservationPageState extends State<ReservationPage> {
  ///This attribute TextEditingController  for departure date
  TextEditingController _dateController = TextEditingController();

  /// create reservation DAO object
  late ReservationDao _reservationDao;
  /// create reservation DAO object
  late CustomerDAO _customerDao;
  /// create reservation DAO object
  late FlightDao _flightDao;

   /// Store reservation when user click a specific item
   Reservation? selectedItem = null; // null varible
  /// This is a flag to represent go to add page or not , if "" do not show add page, otherwise show add page
   String addItem = "";

   ///Selected value for customer
   int? customerSelected;
   ///Selected value for flight
   String? flightSelected;

  ///reservation list to store reservations
  var reservation_list = <Reservation>[];
  ///customer list to store customers
  var customer_list = <Customers>[];
  ///Flight list to store flights
  var flight_list = <Flight>[];

  @override
  void initState() {
    // initialize object, onloaded in HTML
    super.initState();

    // create the database for reservation
    $FloorReservationDatabase.databaseBuilder('reservation_database.db').build().then((database){
      _reservationDao = database.reservationDao;

      // retrieve all reservation items from DB, and add these to the list each time you restart the app
      _reservationDao.getAllReservations().then ( (allItems) {
        setState(() {
          reservation_list.addAll(allItems);
        });
      } );
    });

    // create the database for customer
    $FloorCustomersDatabase.databaseBuilder('customer_database.db').build().then((database){
      _customerDao = database.getDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      _customerDao.getAllCustomers().then ( (allItems) {
        setState(() {
          customer_list.addAll(allItems);
        });
      } );
    });

    // create the database for flight
    $FloorFlightDatabase.databaseBuilder('flight_database.db').build().then((database){
      _flightDao = database.flightDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      _flightDao.getAllFlight().then ( (allItems) {
        setState(() {
          flight_list.addAll(allItems);
        });
      } );
    });

    ReservationRepository.loadData().then((_) {
      _dateController.text = ReservationRepository.date;
    });
  }

  @override
  void dispose() { //unloading the page
    saveDataToRepository();
    super.dispose();
    _dateController.dispose(); //delete memory of _controller
  }

  /// This function is used to display the reservation list
  Widget ListPage() {
    return
      Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              // list header
            const Text("Reservation List", style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.bold, ),),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: const Row(
                children: [
                  Expanded(flex:1, child: Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                  Expanded(flex:2, child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                  Expanded(flex:2, child: Text('Flight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)))
                ],
              ),
            ),
            // if no data in list
            if(reservation_list.isEmpty)
              const Expanded(child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0), // Add some padding at the top
                  child: Text('There are no items in the list', style: TextStyle(fontSize: 18, color: Colors.black,),),
                ),
               )
              )
              // if list not empty
            else
              Expanded(
                  child: ListView.builder(
                      itemCount: reservation_list.length,
                      itemBuilder: (context, rowNumber){
                        return
                        GestureDetector(
                          child:
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child:
                                 Row(
                                    children: [
                                     Expanded(flex:1, child:Text("${rowNumber + 1}", style: TextStyle(fontSize: 16, color: Colors.black54 ),),),
                                      // Text( getCustomerById(reservation_list[rowNumber].customerId) ==null? "Customer not Exist": , style: TextStyle(fontSize: 16, color: Colors.black54 ),),

                                      if(getCustomerById(reservation_list[rowNumber].customerId)==null)
                                          Expanded(flex:2, child:Text( "Customer not Exist", style: TextStyle(fontSize: 16, color: Colors.black54 ),),)
                                      else
                                          Expanded(flex:2, child:Text(getCustomerById(reservation_list[rowNumber].customerId).firstName + " "+ getCustomerById(reservation_list[rowNumber].customerId).lastName, style: TextStyle(fontSize: 16, color: Colors.black54 ),),),

                                    Expanded(flex:2, child:Text( reservation_list[rowNumber].flightId, style: TextStyle(fontSize: 16, color: Colors.black54 ),),)

                              ] ),
                            ),
                            onTap: (){
                                  setState(() {
                                    selectedItem = reservation_list[rowNumber];
                                  });
                            }
                        );
                      }
                  )
              ),


              SizedBox(
                width: double.infinity,
                child: FilledButton(
                   // add button style
                    style: FilledButton.styleFrom(
                      backgroundColor:Theme.of(context).colorScheme.tertiaryContainer,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    //
                    onPressed: () {
                      setState(() {
                        selectedItem = null;
                        addItem = "yes";
                      });
                    },
                    child: const Text("Add New Reservation", style: TextStyle(fontSize:18,color: Colors.black54)),),
              ),
          ],
       )
      );
  }
  ///This function to get a Customer from customer list according to customerId
  Customers getCustomerById(int customerId){

    Customers? customer = customer_list.firstWhere(
          (customer) => customer.customerId == customerId,
    );
    return customer;
  }
  ///This function  get Flight from Flight list according to flightId
  Flight getFlightById(String flightId){

    Flight? flight = flight_list.firstWhere(
          (flight) => flight.flightId == flightId,
    );
    return flight;
  }

  /// A date picker to allow the user to select departure date and to record the value
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  ///This function is used to save date to repository
  Future<void> saveDataToRepository() async {

    // flightSelected !=null? ReservationRepository.flightId = flightSelected! : null;
    // customerSelected != null? ReservationRepository.customerId = customerSelected.toString()! : null;
    ReservationRepository.date = _dateController.value.text;

    await ReservationRepository.saveData();
  }

  ///This function is used to display Add reservation page
  Widget AddPage() {
    return
       Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Add New Reservation", style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.bold),),
          const SizedBox(height: 20),

          // select customer row
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(children: [
              const SizedBox(
                width: 120,
                child:  Text("Customer:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
              ),
            Expanded(
              child:  DropdownButton <int>(
                style: const TextStyle(fontSize: 18, color: Colors.black54,),
                hint: const Text(" select a customer"),
                iconSize: 50,
                isExpanded: true,
                value: customerSelected,
                items: customer_list.map((Customers customer) {
                        return DropdownMenuItem<int>(
                            value: customer.customerId,
                            child: Text(customer.firstName + " "+ customer.lastName),
                        );
                }).toList(),
                onChanged: (int? newValue) {
                      setState(() {
                        customerSelected = newValue!;
                      }); },
              )
            )
            ],),
          ),

          // Flight select row
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(children: [
              const SizedBox(
                width: 120, // fix width
                child: Text("Flight:", style: TextStyle(fontSize: 18, color: Colors.black54, ),),
              ),

            Expanded(
              child: DropdownButton <String>(
                style: const TextStyle(fontSize: 18, color: Colors.black54,),
                iconSize: 40,
                isExpanded: true,
                hint: const Text(" select a flight"),
                value: flightSelected,
                items: flight_list.map((Flight flight) {
                  return DropdownMenuItem<String>(
                    value: flight.flightId,
                    child: Text(flight.flightId + " "+ flight.departureTime + "-"+ flight.arrivalTime),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    flightSelected = newValue!;
                  }); },
              )
            )
            ],),
          ),

          // date select row
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(children: [
              const SizedBox(
                width: 120, // fix width
                child: Text("Date:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
              ),

              Expanded(
                child: TextField(
                  style: TextStyle(fontSize:18, color: Colors.black54, ),
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText:"Select a date",
                    border: OutlineInputBorder(),
                    labelText: "Departure Date",
                    suffixIcon:Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                )
              )
            ],),
          ),
        // Submit and cancel button
        Padding(padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Submit button
              ElevatedButton(
              onPressed: () {
                // check inputs are not empty， if empty show SnackBar
                if(customerSelected == null || flightSelected ==null ||  _dateController.text.isEmpty){
                  // show a snackbar if the input items are empty
                  var snackBar = SnackBar(
                    content: Text('Information can not be empty!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }else{  // if not empty, show showDialog
                  //show AlertDialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add new reservation'),
                        content: Text('Are you sure to save this reservation info?'),
                        actions: <Widget>[
                          //No button in alert dialog
                          ElevatedButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          // Yes button in alert dialog, add reservation
                          FilledButton(
                              child: Text('Yes'),
                              onPressed: (){
                                // add action
                                setState(() {
                                  var reservation = new Reservation(Reservation.ID++, customerSelected!, flightSelected!, _dateController.text);
                                  //add to database
                                  _reservationDao.insertReservation(reservation);
                                  reservation_list.add(reservation);

                                  _dateController.text = "";
                                  customerSelected = null;
                                  flightSelected = null;
                                  addItem = "";
                                });
                                Navigator.pop(context);
                              }
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.black54,)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
            ),

            // Cancel button, return list page
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //reset add items
                  customerSelected = null;
                  flightSelected = null;
                  addItem = "";
                  //clear data from repository
                  ReservationRepository.clearData();
                });
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black54,)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
            ),
        ])
        ),
      ]);
  }

  /// This function to show the detail page of a reservation
  Widget DetailPage() {
    if(selectedItem == null){
      return Column(
        children: [Text("Nothing is selected")],
      );
    }else{
      return
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Reservation Information", style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.bold ),),
              const SizedBox(height: 20),

              // customer row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120,
                    child:  Text("Customer:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(getCustomerById(selectedItem!.customerId).firstName + getCustomerById(selectedItem!.customerId).lastName, style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),

              // Flight row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Flight:", style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                  ),
                  Text(selectedItem!.flightId,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),


              // Departure City row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Departure City:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).departureCity,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),

              // Destination City row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Destination City:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).destinationCity,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),
              // Departure date row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Departure Date:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(selectedItem!.departureTime,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),
              // Departure time row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Departure Time:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).departureTime,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),
              // Arrival time row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                  const SizedBox(
                    width: 120, // fix width
                    child: Text("Arrival Time:", style: TextStyle(fontSize: 18, color: Colors.black54, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).arrivalTime,style: TextStyle(fontSize: 18, color: Colors.black54, ),),
                ],),
              ),
              //
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button, return list page
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedItem = null;
                            });
                          },
                          child: Text("Go Back", style: TextStyle(color: Colors.black54,)),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                        ),
                      ])
              ),
            ]);
    }
  }

  ///This method to display different layouts depending on the screen size
  Widget ResponsiveLayout(){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    //landscape model
    if ((width>height) && (width > 720))
    {
      //This is for default page
      if (selectedItem == null && addItem == "") {
        return Row( children:[
            Expanded( flex: 1, child: ListPage()),
            Expanded( flex: 1, child: Text(" "), ),
          ]);
      }
      //This is for add page
      else if (selectedItem == null && addItem == "yes"){
        return Row( children:[
          Expanded( flex: 1, child: ListPage(),),
          Expanded( flex: 1, child: AddPage(), ),
        ]);
      }
      //This is for detail page
      else if (selectedItem != null && addItem == "") {
        return Row( children:[
          Expanded( flex: 1, child: ListPage(),),
          Expanded( flex: 1, child: DetailPage(),),]);
      }
      else return  Text(" ");
    }
    // portrait model
    else
    {
      if (selectedItem == null && addItem == "") {
        return ListPage();

      } else if (selectedItem == null && addItem == "yes") {
        return AddPage();

      } else if (selectedItem != null && addItem == "") {
        return DetailPage();

      }
      else return Text(" ");

    }
  }
  ///This function is used to display instructions for how to use the interface
  void showCustomDialog(BuildContext context, String value) {
    String dialogTitle;
    Widget dialogContent;

    switch (value) {
      case 'View':
        dialogTitle = 'How to view the Reservation List?';
        dialogContent = Text('The Reservation List would show the whole screen on the Phone, but on a Tablet or Desktop screen, '
            'it would show the List on the left screen.');
        break;
      case 'Add':
        dialogTitle = 'How to add a new Reservation?';
        dialogContent = Text('You can click the button: "Add New Reservation" in the bottom, a add page will show in the screen, '
            'you can add new Reservation with information of: customer name, flight, and departure date, '
            'Then click the "Submit" button to add it.');
        break;
      case 'Detail':
        dialogTitle = 'How to view a Reservation detail?';
        dialogContent = Text('You can tap one of reservation from the reservation list: a reservation page will show in the screen, '
            'but on a Tablet or Desktop screen, it would show the List on the left screen.'
            'You can click the "Go back" button to return to list page.');
        break;
      default:
        dialogTitle = 'Unknown';
        dialogContent = Text('No information available.');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: dialogContent,
          actions: <Widget>[
            TextButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  /// Override build() method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          title: Text("Reservation", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, ) ),
          actions: [
            TextButton(
              onPressed: (){
                setState(() {
                  if(selectedItem != null){
                    selectedItem = null;
                  }else if (!addItem.isEmpty){
                    addItem = "";
                  }else{
                    Navigator.pop(context);
                  }

                });
              },
              child: Text("Go Back", style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold),)
            ),
            SizedBox(width: 20),
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Handle the menu item action here
                showCustomDialog(context, value); // Example action: print the selected value
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'View',
                  child: Text('How to view the Reservation List?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Add',
                  child: Text('How to add a new Reservation?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Detail',
                  child: Text('How to view a Reservation detail?'),
                ),
              ],
              child: Text("Help", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
            ),

            SizedBox(width: 20),

          ]
      ),
      body: Center(
          child: ResponsiveLayout()
      ),

    );

  }
}