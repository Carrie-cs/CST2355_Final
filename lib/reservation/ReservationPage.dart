
import 'package:cst2335final/CustomerList/CustomerDAO.dart';
import 'package:cst2335final/CustomerList/Customers.dart';
import 'package:cst2335final/CustomerList/CustomersDatabase.dart';
import 'package:cst2335final/flight/flight.dart';
import 'package:cst2335final/flight/flight_dao.dart';
import 'package:cst2335final/flight/flight_database.dart';
import 'package:cst2335final/reservation/Resercvation.dart';
import 'package:cst2335final/reservation/ReservationDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'ReservationDatabase.dart';


class ReservationPage extends StatefulWidget { // stateful means has variables
  @override
  State<ReservationPage> createState() => ReservationPageState();
}

class ReservationPageState extends State<ReservationPage> {

  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  /// create reservation DAO object
  late ReservationDao _reservationDao;
  /// create reservation DAO object
  late CustomerDAO _customerDao;
  /// create reservation DAO object
  late FlightDao _flightDao;

   /// Store reservation when user click a specific item
   Reservation? selectedItem = null; // null varible
  /// This is a goto add page flag, if "" not show add page, otherwise show add page
   String addItem = "";

   /// Initial Selected Value
   // String? customerSelected;
   int? customerSelected;
   /// Initial Selected Value
   String? flightSelected;

  ///reservation list
  var reservation_list = <Reservation>[];
  // var customer_list = <Customer>["Lili","Rose","Anna","Elsa"];
  ///customer list
  var customer_list = <Customers>[];
  ///Flight list
  var flight_list = <Flight>[];

  @override
  void initState() {
    // initialize object, onloaded in HTML
    super.initState();
    // _controllerDate = TextEditingController();

    // create the database
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorReservationDatabase.databaseBuilder('reservation_database.db').build().then((database){
      _reservationDao = database.reservationDao;

      // retrieve all reservation items from DB, and add these to the list each time you restart the app
      _reservationDao.getAllReservations().then ( (allItems) {
        setState(() {
          reservation_list.addAll(allItems);
        });
      } );
    });

    // create the database
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorCustomersDatabase.databaseBuilder('customer_database.db').build().then((database){
      _customerDao = database.getDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      _customerDao.getAllCustomers().then ( (allItems) {
        setState(() {
          customer_list.addAll(allItems);
        });
      } );
    });

    // create the database
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorFlightDatabase.databaseBuilder('flight_database.db').build().then((database){
      _flightDao = database.flightDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      _flightDao.getAllFlight().then ( (allItems) {
        setState(() {
          flight_list.addAll(allItems);
        });
      } );
    });
  }

  @override
  void dispose() { //unloading the page
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
            const Text("Reservations ", style: TextStyle(fontSize: 24, color: Colors.black54, fontWeight: FontWeight.bold, ),),
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
                           Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Row Number: ${rowNumber}", style: TextStyle(fontSize: 16, color: Colors.black54 ),),
                                // Text( getCustomerById(reservation_list[rowNumber].customerId) ==null? "Customer not Exist": , style: TextStyle(fontSize: 16, color: Colors.black54 ),),

                                if(getCustomerById(reservation_list[rowNumber].customerId)==null)
                                  Text( "Customer not Exist", style: TextStyle(fontSize: 16, color: Colors.black54 ),)
                                else
                                  Text(getCustomerById(reservation_list[rowNumber].customerId).firstName + " "+ getCustomerById(reservation_list[rowNumber].customerId).lastName, style: TextStyle(fontSize: 16, color: Colors.black54 ),),

                                Text( "airplane[rowNum].type", style: TextStyle(fontSize: 16, color: Colors.black54 ),),

                              ] ),


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
                    child: const Text("Add New Reservation", style: TextStyle(fontSize: 20,color: Colors.black54)),),
              ),
          ],
       )
      );
  }
  ///get Customer from customer list according to customerId
  Customers getCustomerById(int customerId){

    Customers? customer = customer_list.firstWhere(
          (customer) => customer.customerId == customerId,
    );
    return customer;
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


  /// Add reservation page
  Widget AddPage() {
    return
       Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Add New Reservation", style: TextStyle(fontSize: 24, color: Colors.black54, ),),
          const SizedBox(height: 40),

          // select customer row
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(children: [
              const SizedBox(
                width: 130,
                child:  Text("Customer:", style: TextStyle(fontSize: 24, color: Colors.black54, )),
              ),
            Expanded(
              child:  DropdownButton <int>(
                style: const TextStyle(fontSize: 24, color: Colors.black54,),
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
                width: 130, // fix width
                child: Text("Flight:", style: TextStyle(fontSize: 24, color: Colors.black54, ),),
              ),

            Expanded(
              child: DropdownButton <String>(
                style: const TextStyle(fontSize: 24, color: Colors.black54,),
                iconSize: 50,
                isExpanded: true,
                hint: const Text(" select a flight"),
                value: flightSelected,
                items: flight_list.map((Flight flight) {
                  return DropdownMenuItem<String>(
                    value: flight.flightId,
                    child: Text(flight.flightId),
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
                width: 130, // fix width
                child: Text("Date:", style: TextStyle(fontSize: 24, color: Colors.black54, )),
              ),

              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 24, color: Colors.black54, ),
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
        //
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
              child: Text("Submit", style: TextStyle(fontSize: 24,color: Colors.black54,)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
            ),

            // Cancel button, return list page
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addItem = "";
                });
              },
              child: Text("Cancel", style: TextStyle(fontSize: 24,color: Colors.black54,)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
            ),
        ])
        ),
      ]);
  }


  Widget DetailPage() {
    if(selectedItem == null){
      return Column(
        children: [Text("Nothing is selected")],
      );
    }else{
      return Center(
        child: Column(
          children: [
            Text("Todo item: "),// ! means assert non-null(garenteen not null), selectedItem is String
            Text("Id in database: "),
            // Text("${selectedRowNum}"),

          ],),
      );
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

  void showCustomDialog(BuildContext context, String value) {
    String dialogTitle;
    Widget dialogContent;

    switch (value) {
      case 'View':
        dialogTitle = 'How to view the Airplane List?';
        dialogContent = Text('The Airplane List would show the whole screen on the Phone, but on a Tablet or Desktop screen, '
            'it would show the List on the left screen.');
        break;
      case 'Add':
        dialogTitle = 'How to add the new Airplane?';
        dialogContent = Text('You can click the button: "Add Airplane" in the bottom, a add page will show in the screen, '
            'you can add new Airplane with information of: airplane type, the number of passengers, the maximum speed, '
            'and the range or distance the plane can fly. And click the "Submit the new Airplane Type" button to add it.');
        break;
      case 'Update':
        dialogTitle = 'How to update the Airplane?';
        dialogContent = Text('You can tap the Airplane list (e.g.: Airplane Type 1: XXX) to see details of each item, and a detailed page will show in the screen. '
            'Update any information you need, and then click the "Update" button to update the Airplane.');
        break;
      case 'Delete':
        dialogTitle = 'How to delete the Airplane?';
        dialogContent = Text('You can tap the Airplane list (e.g.: Airplane Type 1: XXX) to see details of each item, and a detailed page will show in the screen. '
            'and then click the "Delete" button to delete the Airplane.');
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          title: Text("Reservation", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, ) ),
          actions: [
            TextButton(
              onPressed: () {
                  setState(() {

                  });
              },
              child:Text("Clear the Selected Item", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, )),
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
                  child: Text('How to view the Airplane List?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Add',
                  child: Text('How to add the new Airplane?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Update',
                  child: Text('How to update the Airplane?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('How to delete the Airplane?'),
                ),
              ],
              child: Text("Help", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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