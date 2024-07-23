import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'CustomerDAO.dart';
import 'CustomersDatabase.dart';
import 'Customers.dart';
import 'CustomerRepository.dart';

/// The CustomerPage displays a page where users can view, add, update and delete customer's information.
class CustomerPage extends StatefulWidget { // stateful means has variables
  @override
  State<CustomerPage> createState() => CustomerPageState();
}

class CustomerPageState extends State<CustomerPage> {
  /// these controllers record the value of first name, last name, address. birthday
  late TextEditingController _controllerFirstName;
  late TextEditingController _controllerLastName;
  late TextEditingController _controllerAddress;
  late TextEditingController _controllerBirthday;
  DateTime? _birthdayDate;


  /// create a DAO object
  late CustomerDAO myDAO;

  /// The list of customers retrieved from the database.
  List<Customers> customer =  [] ; // empty array

  /// The currently selected customer for viewing or editing details.
  Customers? selectedCustomer = null;

  /// Indicates whether the user is adding a new customer or not.
  String addCustomer = "";

/// Initializes the state of the `CustomerPageState` class
  @override
  void initState() {
    // initialize object, onloaded in HTML
    super.initState();
    _controllerFirstName = TextEditingController();
    _controllerLastName = TextEditingController();
    _controllerAddress = TextEditingController();
    _controllerBirthday = TextEditingController();

    // create the database
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorCustomersDatabase.databaseBuilder('customer_database.db').build().then((database){
      myDAO = database.getDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      myDAO.getAllCustomers().then ( (allItems) {
        setState(() {
          customer.addAll(allItems);
        });
      } );
    });
  }
/// Releases the resources
  @override
  void dispose() {
    super.dispose();
    _controllerFirstName.dispose(); //delete memory of _controller
    _controllerLastName.dispose();
    _controllerAddress.dispose();
    _controllerBirthday.dispose();

  }
  /// A date picker to allow the user to select birthday and to record the value
  Future<void> _selectDate(BuildContext context) async{
    final DateTime? date = await showDatePicker(
      context:context,
      initialDate:_birthdayDate?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate:DateTime(2100),
    );
    if (date != null && date != _birthdayDate) {
      setState(() {
        _birthdayDate = date;
        _controllerBirthday.text = "${_birthdayDate!.year}-${_birthdayDate!.month.toString().padLeft(2, '0')}-${_birthdayDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }
/// Shows a dialog asking whether to start with a blank page or copy fields from the previous customer.
  void chooseBlockOrCopy(){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Do you want to start with a blank page or '
              'copy the fields from the previous customer?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedCustomer= null;
                  addCustomer = "yes";

                  // load the data stored in repository
                  CustomerRepository.loadData().then((_) {
                    _controllerFirstName.text = CustomerRepository.firstName;
                    _controllerLastName.text = CustomerRepository.lastName;
                    _controllerAddress.text = CustomerRepository.address;
                    _controllerBirthday.text = CustomerRepository.birthday;
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Copy the fields",style: TextStyle(color: Colors.green)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {

                  selectedCustomer= null;
                  addCustomer = "yes";
                  CustomerRepository.clearData();
                  _controllerFirstName.text = "";
                  _controllerLastName.text = "";
                  _controllerAddress.text ="";
                  _controllerBirthday.text = "";
                });


                Navigator.pop(context);
              },
              child: const Text("Start with a blank page",style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );

  }
/// Builds a widget displaying the list of customers.
  Widget CustomerList() {

    return Scaffold(

      backgroundColor: Colors.green[50]?.withOpacity(0.5),

      body: Center(
          child: Column( mainAxisAlignment: MainAxisAlignment.center, children:<Widget>[
            const SizedBox(height: 90),

            Text("Current Customer List: ", style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold, ),),

            const SizedBox(height: 20),

            // ListView
            Flexible(
                child: customer.isEmpty
                // Display this when list is empty
                    ?
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.0), // Add some padding at the top
                    child: Text('There are no items in the list', style: TextStyle(fontSize: 18, color: Colors.green,),),
                  ),
                )

                // display the ListView when has some item
                    : ListView.builder(
                    itemCount: customer.length,
                    itemBuilder: (context, rowNum) {
                      return  Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
                          child:  GestureDetector(child:
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text( customer[rowNum].firstName, style: TextStyle(fontSize: 18, color: Colors.green ),),
                                Text( customer[rowNum].lastName, style: TextStyle(fontSize: 18, color: Colors.green ),),
                                Text( customer[rowNum].address, style: TextStyle(fontSize: 18, color: Colors.green ),),
                                Text( customer[rowNum].birthday, style: TextStyle(fontSize: 18, color: Colors.green ),)
                              ]
                          ),
                              //onDoubleTap(){}; onLongPress(){}; onHorizontalDragUpdate(){}
                              onTap: () {
                                setState(() {
                                  addCustomer = "";
                                  selectedCustomer = customer[rowNum];

                                  // load the data stored in database
                                  _controllerFirstName.text = selectedCustomer!.firstName;
                                  _controllerLastName.text = selectedCustomer!.lastName;
                                  _controllerAddress.text =  selectedCustomer!.address;
                                  _controllerBirthday.text =  selectedCustomer!.birthday;

                                });
                              } // on Tap
                          )
                      );
                    }
                )
            ),

            Container(
              padding: EdgeInsets.all(30),
              child: Row( mainAxisAlignment: MainAxisAlignment.center, children:[
                ElevatedButton( child: Text("Add Customer",  style: TextStyle(fontSize: 15, color:Colors.green, fontWeight: FontWeight.bold, ) ),
              onPressed: chooseBlockOrCopy,)]),
            ),

          ],
          )
      ),
    );
  }
/// Builds a widget for adding a new customer.
  Widget appCustomerPage() {

    return Scaffold(

      backgroundColor: Colors.green[50]?.withOpacity(0.5),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text("Add New Customer: ", style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold, ),),

            const SizedBox(height: 40),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerFirstName,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Customer First Name",
                ),
              enableInteractiveSelection: false,
            )),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerLastName,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Customer Last Name"
                ),
              enableInteractiveSelection: false,)),


            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerAddress,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Customer Address"
                ),
              enableInteractiveSelection: false,)),


            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerBirthday,
                decoration: InputDecoration(
                    hintText:"Select Birthday",
                    border: OutlineInputBorder(),
                    labelText: "Customer Birthday",
                  suffixIcon:IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ) ,
                ),
              readOnly: true,
            ),
            ),


            const SizedBox(height: 50),

            ElevatedButton( onPressed: (){

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Customer Info'),
                    content: Text('Do you want to add this customer info?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                          child: Text('Yes'),
                          onPressed: buttonClicked
                      ),
                    ],
                  );
                },
              );
            },
              child:  Text("Submit", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.green )),  ),

          ],
        ),
      ),
    );

  }


  /// Check the values of fields is empty or not
  bool validateCustomerInfo() {
    if (_controllerFirstName.text.isEmpty ||
        _controllerLastName.text.isEmpty ||
        _controllerAddress.text.isEmpty ||
        _controllerBirthday.text.isEmpty) {
      // One or more fields are empty
      return false;
    }
    // All fields have values
    return true;
  }



  /// This function gets run when you click the button
  void buttonClicked() async {

    // store data in the database
    if (validateCustomerInfo()) {

      //store the data in repository
      CustomerRepository.firstName = _controllerFirstName.value.text;
      CustomerRepository.lastName = _controllerLastName.value.text;
      CustomerRepository.address = _controllerAddress.value.text;
      CustomerRepository.birthday = _controllerBirthday.value.text;

      await CustomerRepository.saveData();
      var enterFirstName = _controllerFirstName.value.text;
      var enterLastName= _controllerLastName.value.text;
      var enterAddress =  _controllerAddress.value.text;
      var enterBirthday =  _controllerBirthday.value.text;


      setState(() {
        // also insert the database
        var newCustomer = Customers(Customers.ID++, enterFirstName, enterLastName, enterAddress, enterBirthday);
        myDAO.insertCustomer(newCustomer);
        // add what you typed
        customer.add(newCustomer);

      });

      // clear the text field
      _controllerFirstName.text = "";
      _controllerLastName.text = "";
      _controllerAddress.text = "";
      _controllerBirthday.text = "";

      addCustomer = "";

      Navigator.of(context).pop();

      // show a snackbar if the delete the item
      var snackBar = SnackBar(
        content: Text('Customer info successfully added!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    else
    {
      // One or more fields are empty, show a dialog box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all customer fields.'),
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

  }

/// Builds the widget of customer details page
  Widget DetailsPage() {
    if (selectedCustomer == null) {
      return Text(" ");
    }
    else {
      return Scaffold(

          backgroundColor: Colors.green[50]?.withOpacity(0.5),

          body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text("Details of Customers ",
                    style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold, ),),

                  const SizedBox(height: 40),


                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerFirstName,
                      decoration: InputDecoration(
                        hintText:"Type here",
                        border: OutlineInputBorder(),
                        labelText: "Customer First Name",
                      ))),

                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerLastName,
                      decoration: InputDecoration(
                          hintText:"Type here",
                          border: OutlineInputBorder(),
                          labelText: "Customer Last Name"
                      ))),

                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerAddress,
                      decoration: InputDecoration(
                          hintText:"Type here",
                          border: OutlineInputBorder(),
                          labelText: "Customer Address"
                      ))),


                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerBirthday,
                    decoration: InputDecoration(
                      hintText:"Select Birthday",
                      border: OutlineInputBorder(),
                      labelText: "Customer Birthday",
                      suffixIcon:IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ) ,
                    ),
                    readOnly: true,
                  ),
                  ),

                  const SizedBox(height: 50),


                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        ElevatedButton( onPressed: (){

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update'),
                                content: Text("Do you want to update this customer's information?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                      child: Text('Yes'),
                                      onPressed: updateClicked
                                  ),
                                ],
                              );
                            },
                          );
                        }, child:  Text("Update", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.green ))  ),

                        SizedBox(width: 20),

                        ElevatedButton(onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete'),
                                content: Text("Do you want to delete this customer's information?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        // delete from the database first, then delete the list
                                        myDAO.deleteCustomer(selectedCustomer!).then((_) {
                                          // Once the item is deleted from the database,  delete the list
                                          setState(() {
                                            // Remove the item from the list
                                            customer.removeWhere((item) => item.customerId == selectedCustomer!.customerId);
                                            // Reset selectedItem to null
                                            selectedCustomer = null;
                                          });
                                        });
                                      });
                                      Navigator.of(context).pop(); // Close the dialog
                                      // show a snackbar if the delete the item
                                      var snackBar = SnackBar(
                                        content: Text('Successfully deleted!'),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }, child:  Text("Delete", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.green )))
                      ]
                  ),
                ],
              )
          )
      );
    }
  }

/// Update customer information logics
  Future<void> updateClicked () async {

    // Update the existing item
    var updatedCustomer = Customers(
      selectedCustomer!.customerId,
      _controllerFirstName.value.text,
      _controllerLastName.value.text,
      _controllerAddress.value.text,
      _controllerBirthday.value.text,
    );
    await myDAO.updateCustomer(updatedCustomer);
    // Update the item in the list
    int index = customer.indexWhere((item) => item.customerId == selectedCustomer!.customerId);
    setState(() {
      customer[index] = updatedCustomer;
    });

    // clear the text field
    _controllerFirstName.text = "";
    _controllerLastName.text = "";
    _controllerAddress.text = "";
    _controllerBirthday.text = "";

    selectedCustomer = null;


    Navigator.of(context).pop();

    // show a snackbar if the delete the item
    var snackBar = SnackBar(
      content: Text('Successfully Updated!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);


  }
/// Display different pages according to page size
  Widget ResponsiveLayout(){

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width>height) && (width > 720))
    {
      if (selectedCustomer == null && addCustomer == "") {
        return Row( children:[
          Flexible( flex: 1, child: CustomerList(),),
          Flexible(flex: 1, child: Text(" "))]);
      }
      else if (selectedCustomer == null && addCustomer == "yes"){
        return Row( children:[
            Flexible( flex: 1, child: CustomerList(),),
          Flexible(flex: 1, child: appCustomerPage()),]);
      }
      else if (selectedCustomer != null && addCustomer == "") {
        return Row( children:[
          Flexible( flex: 1, child: CustomerList(),),
          Flexible(flex: 1, child: DetailsPage())
        ]);
      }
      else return  Text(" ");
    }

    // portrait
    else
    {
      if (selectedCustomer == null && addCustomer == "")
      {
        return CustomerList();
      }
      else if (selectedCustomer == null && addCustomer == "yes") {
        return appCustomerPage();
      }
      else if (selectedCustomer != null && addCustomer == "") {
        return DetailsPage();
      }
      else return Text(" ");

    }
  }
/// Introduce the user to the basic operation of this page
  void showCustomDialog(BuildContext context, String value) {
    String dialogTitle;
    Widget dialogContent;

    switch (value) {
      case 'View':
        dialogTitle = 'How to view the Customer List?';
        dialogContent = Text('The Customer List would show the whole screen on the Phone, but on a Tablet or Desktop screen, '
            'it would show the List on the left screen.');
        break;
      case 'Add':
        dialogTitle = 'How to add new Customer?';
        dialogContent = Text('You can click the button: "Add" in the bottom, a add page will show in the screen, '
            'you can add new Customer with information of: first name, last name, address, '
            'and birthday. And click the "Submit" button to add it.');
        break;
      case 'Update':
        dialogTitle = 'How to update the Customer?';
        dialogContent = Text('You can tap the Customer list to see details of each customer, and a detailed page will show in the screen. '
            'Update any information you need, and then click the "Update" button to update the Customer.');
        break;
      case 'Delete':
        dialogTitle = 'How to delete the Customer?';
        dialogContent = Text('You can tap the Customer list to see details of each customer, and a detailed page will show in the screen. '
            'and then click the "Delete" button to delete the customer.');
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

/// Creates a `Scaffold` widget with an `AppBar` and a body containing the `ResponsiveLayout` widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Customer", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, ) ),
          actions: [
            TextButton(onPressed: () {
              setState(() {
                addCustomer = "";
                selectedCustomer = null;
              });
            },
              child:Text("Clear the Selected Customer", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.green )),
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
                  child: Text('How to view the Customer List?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Add',
                  child: Text('How to add the new Customer?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Update',
                  child: Text('How to update the Customer?'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('How to delete the Customer?'),
                ),
              ],
              child: Text("Help", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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