
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
import '../AppLocalizations.dart';
import '../main.dart';
import 'ReservationDatabase.dart';
import 'ReservationRepository.dart';
/// This is the reservation page of the application.
/// This page lists all the reservation and provides functionality to add, view detail reservation.
///
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
              const SizedBox(height: 20),
              // list header
              Text(AppLocalizations.of(context)!.translate('reservation_header_list')!, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold, ),),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
              child: Row(
                children: [
                  Expanded(flex:1, child: Text(AppLocalizations.of(context)!.translate('reservation_row')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('reservation_customer')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('reservation_flight')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black))),
                  Expanded(flex:2, child: Text(AppLocalizations.of(context)!.translate('reservation_departure_date')!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)))
                ],
              ),
            ),
            // if no data in list
            if(reservation_list.isEmpty)
               Expanded(child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0), // Add some padding at the top
                  child: Text(AppLocalizations.of(context)!.translate('reservation_no_data')!, style: TextStyle(fontSize: 18, color: Colors.black,),),
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
                                     Expanded(flex:1, child:Text("${rowNumber + 1}", style: TextStyle(fontSize: 16, color: Colors.black87 ),),),
                                      // Text( getCustomerById(reservation_list[rowNumber].customerId) ==null? "Customer not Exist": , style: TextStyle(fontSize: 16, color: Colors.black87 ),),

                                      if(getCustomerById(reservation_list[rowNumber].customerId)==null)
                                          Expanded(flex:2, child:Text( AppLocalizations.of(context)!.translate('reservation_no_customer')!, style: TextStyle(fontSize: 16, color: Colors.black87 ),),)
                                      else
                                          Expanded(flex:2, child:Text(getCustomerById(reservation_list[rowNumber].customerId).firstName + " "+ getCustomerById(reservation_list[rowNumber].customerId).lastName, style: TextStyle(fontSize: 16, color: Colors.black87 ),),),

                                    Expanded(flex:2, child:Text( reservation_list[rowNumber].flightId, style: TextStyle(fontSize: 16, color: Colors.black87 ),),),
                                    Expanded(flex:2, child:Text( reservation_list[rowNumber].departureTime, style: TextStyle(fontSize: 16, color: Colors.black87 ),),)

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
                    child: Text(AppLocalizations.of(context)!.translate('reservation_add')!, style: TextStyle(fontSize:18,color: Colors.black87)),),
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
          Text(AppLocalizations.of(context)!.translate('reservation_add')!, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10),

          // select customer row
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(children: [
               SizedBox(
                width: 120,
                child:  Text(AppLocalizations.of(context)!.translate('reservation_customer')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
              ),
            Expanded(
              child:  DropdownButton <int>(
                style: const TextStyle(fontSize: 18, color: Colors.black87,),
                hint: Text(AppLocalizations.of(context)!.translate('reservation_select_customer')!),
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
               SizedBox(
                width: 120, // fix width
                child: Text(AppLocalizations.of(context)!.translate('reservation_flight')!, style: TextStyle(fontSize: 18, color: Colors.black87, ),),
              ),

            Expanded(
              child: DropdownButton <String>(
                style: const TextStyle(fontSize: 18, color: Colors.black87,),
                iconSize: 40,
                isExpanded: true,
                hint:  Text(AppLocalizations.of(context)!.translate('reservation_select_flight')!),
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
               SizedBox(
                width: 120, // fix width
                child: Text(AppLocalizations.of(context)!.translate('reservation_departure_date')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
              ),

              Expanded(
                child: TextField(
                  style: TextStyle(fontSize:18, color: Colors.black87, ),
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.translate('reservation_select_date')!,
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.translate('reservation_departure_date')!,
                    suffixIcon:Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                )
              )
            ],),
          ),
        // Submit and cancel button
        Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                    content: Text(AppLocalizations.of(context)!.translate('reservation_not_empty')!),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }else{  // if not empty, show showDialog
                  // check if the reservation already exist
                  bool exists = reservation_list.any((reservation) =>
                      reservation.customerId == customerSelected &&
                      reservation.flightId == flightSelected &&
                      reservation.departureTime == _dateController.text );
                  // if the reservation does exist
                  if( exists){
                      var snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.translate('reservation_exist')!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else {
                    //show AlertDialog
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.translate(
                                'reservation_add')!),
                            content: Text(
                                AppLocalizations.of(context)!.translate(
                                    'reservation_add_alert')!),
                            actions: <Widget>[
                              //No button in alert dialog
                              ElevatedButton(
                                child: Text(
                                    AppLocalizations.of(context)!.translate(
                                        'No')!),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                              // Yes button in alert dialog, add reservation
                              FilledButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'Yes')!),
                                  onPressed: () {
                                    // add action
                                    setState(() {
                                      var reservation = new Reservation(
                                          Reservation.ID++, customerSelected!,
                                          flightSelected!,
                                          _dateController.text);
                                      //add to database
                                      _reservationDao.insertReservation(
                                          reservation);
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
                        }
                    );
                  }
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
              child: Text(AppLocalizations.of(context)!.translate('submit')!, style: TextStyle(color: Colors.black87,)),
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
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
              child: Text(AppLocalizations.of(context)!.translate('cancel')!, style: TextStyle(color: Colors.black87,)),
            ),
        ])
        ),
      ]);
  }

  /// This function to show the detail page of a reservation
  Widget DetailPage() {
      return
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.translate('reservation_detail')!, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold ),),
              const SizedBox(height: 10),

              // customer row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120,
                    child:  Text(AppLocalizations.of(context)!.translate('reservation_customer')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(getCustomerById(selectedItem!.customerId).firstName +" "+ getCustomerById(selectedItem!.customerId).lastName, style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),

              // Flight row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_flight')!, style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                  ),
                  Text(selectedItem!.flightId,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),


              // Departure City row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_departure_city')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).departureCity,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),

              // Destination City row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_destination_city')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).destinationCity,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),
              // Departure date row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_departure_date')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(selectedItem!.departureTime,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),
              // Departure time row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_departure_time')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).departureTime,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),
              // Arrival time row
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:Row(children: [
                   SizedBox(
                    width: 120, // fix width
                    child: Text(AppLocalizations.of(context)!.translate('reservation_arrival_time')!, style: TextStyle(fontSize: 18, color: Colors.black87, )),
                  ),
                  Text(getFlightById(selectedItem!.flightId).arrivalTime,style: TextStyle(fontSize: 18, color: Colors.black87, ),),
                ],),
              ),
              //
              Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                          child: Text(AppLocalizations.of(context)!.translate('reservation_go_back')!, style: TextStyle(color: Colors.black87,)),
                        ),
                      ])
              ),
            ]);

  }

  ///This method to display different layouts depending on the screen size
  Widget ResponsiveLayout(){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    //landscape model
    if ((width>height) && (width > 720))
    {
      //This is for default list page
      if (selectedItem == null && addItem == "") {
        return Row( children:[
            Expanded( flex: 1, child: ListPage()),
            Expanded( flex: 1, child: Center(child: Text(AppLocalizations.of(context)!.translate('reservation_hint')!),) ),
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
      else if (selectedItem != null) {
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
        dialogTitle = AppLocalizations.of(context)!.translate('how_view_reservation_list_')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('how_view_reservation_list')!);
        break;
      case 'Add':
        dialogTitle = AppLocalizations.of(context)!.translate('how_add_reservation_')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('how_add_reservation')!);
        break;
      case 'Detail':
        dialogTitle = AppLocalizations.of(context)!.translate('how_view_reservation_detail_')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('how_view_reservation_detail')!);
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
              child: Text(AppLocalizations.of(context)!.translate('Got_it')!),
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
          title: Text(AppLocalizations.of(context)!.translate('reservation')!, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, ) ),
          actions: [
            // Button to switch to English
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("en", "CA") ); }, child:Text("English", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, ))),
            // Button to switch to Chinese
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("zh", "CH") );  }, child:Text("中文", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, ))),

            SizedBox(width: 20),
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Handle the menu item action here
                showCustomDialog(context, value); // Example action: print the selected value
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                 PopupMenuItem<String>(
                  value: 'View',
                  child: Text(AppLocalizations.of(context)!.translate('how_view_reservation_list_')!),
                ),
                 PopupMenuItem<String>(
                  value: 'Add',
                  child: Text(AppLocalizations.of(context)!.translate('how_add_reservation_')!),
                ),
                 PopupMenuItem<String>(
                  value: 'Detail',
                  child: Text(AppLocalizations.of(context)!.translate('how_view_reservation_detail_')!),
                ),
              ],
              child: Text(AppLocalizations.of(context)!.translate('Help')!, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),

            SizedBox(width: 20),
          ]
      ),
      body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
            Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          ResponsiveLayout()
        ]
      )
    );

  }
}