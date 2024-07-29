



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../AppLocalizations.dart';
import '../main.dart';
import 'AirplaneDAO.dart';
import 'AirplaneDatabase.dart';
import 'AirplaneItem.dart';
import 'AirplaneRepository.dart';


/// This is the AirplanePage class.
///
/// This class represents a list of airplanes.
/// It allows users to add, view, and select airplane items.
///
/// @author: WANG JIAYUN
class AirplanePage extends StatefulWidget { // stateful means has variables
  @override
  State<AirplanePage> createState() => AirplanePageState();
}


class AirplanePageState extends State<AirplanePage> {
  /// Controllers for text input fields.
  ///
  /// These controllers are used to manage the text input for airplane type,
  /// number of passengers, max speed, and fly distance.
  late TextEditingController _controllerType; // late means initialize later, but not null
  late TextEditingController _controllerNumOfPassenger;
  late TextEditingController _controllerMaxSpeed;
  late TextEditingController _controllerFlyDistance;


  /// DAO object to interact with the database.
  ///
  /// This object is used to perform CRUD operations on the airplane database.
  late AirplaneDAO myDAO;
  /// List to store airplane items.
  ///
  /// This list is used to display the airplane items in the UI.
  List<AirplaneItem> airplane =  [] ; // empty array
  /// The currently selected airplane item.
  ///
  /// This variable is used to keep track of the selected airplane item.
  AirplaneItem? selectedItem = null;
  /// Flag to indicate if an item is being added.
  ///
  /// This variable is used to manage the state of the UI when adding a new item.
  String addItem = "";


  @override
  void initState() {
    // initialize object, onloaded in HTML
    super.initState();

    // Initialize text controllers.
    _controllerType = TextEditingController();
    _controllerNumOfPassenger = TextEditingController();
    _controllerMaxSpeed = TextEditingController();
    _controllerFlyDistance = TextEditingController();

    // Create the database and retrieve all items.
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build().then((database){
      myDAO = database.itemDao;

      // Retrieve all items from the database and add them to the list.
      myDAO.getAllItems().then ( (allItems) {
        setState(() {
          airplane.addAll(allItems);
        });
      } );

    });

  }



  @override
  void dispose() {
    super.dispose();
    // Dispose of text controllers to free up memory.
    _controllerType.dispose();
    _controllerNumOfPassenger.dispose();
    _controllerMaxSpeed.dispose();
    _controllerFlyDistance.dispose();

  }





  /// Builds the UI for the airplane list.
  ///
  /// This method returns a Scaffold widget that contains the UI elements
  /// for displaying the list of airplanes and managing user interactions.
  Widget AirplaneList() {

    return Scaffold(
      // Set the background color of the Scaffold
      backgroundColor: Colors.deepPurple[50]?.withOpacity(0.5),

      // Center the content of the Scaffold
      body: Center(
          child: Column( mainAxisAlignment: MainAxisAlignment.center, children:<Widget>[
            // Add some space at the top
            const SizedBox(height: 90),
            // Display the title of the page
            Text(AppLocalizations.of(context)!.translate('Airplane_List')!, style: TextStyle(fontSize: 24, color: Colors.purple, fontWeight: FontWeight.bold, ),),
            // Add some space below the title
            const SizedBox(height: 20),

            // Expanded widget to fill available space
            Expanded(
                child: airplane.isEmpty
                // Display this when the list is empty
                    ?
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0), // Add some padding at the top
                    child: Text(AppLocalizations.of(context)!.translate('Airplane_no_list')!, style: TextStyle(fontSize: 18, color: Colors.indigoAccent,),),
                  ),
                )

                // Display the ListView when it has some items
                    : ListView.builder(
                    itemCount: airplane.length,
                    itemBuilder: (context, rowNum) {
                      return  Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
                          child:  GestureDetector(child:
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Display the label for airplane type
                                Text(AppLocalizations.of(context)!.translate('Airplane_Type')!, style: TextStyle(fontSize: 18, color: Colors.purple ),),
                                // Display the row number
                                Text("${rowNum+1}: ", style: TextStyle(fontSize: 18, color: Colors.purple ),),
                                // Display the airplane type
                                Text( airplane[rowNum].type, style: TextStyle(fontSize: 18, color: Colors.purple ),),
                              ]
                          ),
                              // Handle tap event
                              onTap: () {
                                setState(() {
                                  addItem = "";
                                  selectedItem = airplane[rowNum];

                                  // Load the data stored in the database
                                  _controllerType.text = selectedItem!.type;
                                  _controllerNumOfPassenger.text = selectedItem!.numOfPassenger.toString();
                                  _controllerMaxSpeed.text =  selectedItem!.maxSpeed.toString();
                                  _controllerFlyDistance.text =  selectedItem!.flyDistance.toString();

                                });
                              } // on Tap
                          )
                      );
                    }
                )
            ),


            // Container for the Add Airplane button
            Container(
              padding: EdgeInsets.all(30),
              child: Row( mainAxisAlignment: MainAxisAlignment.center, children:[
                // Add Airplane button
                ElevatedButton( child: Text(AppLocalizations.of(context)!.translate('Add_Airplane')!,  style: TextStyle(fontSize: 15, color:Colors.purple, fontWeight: FontWeight.bold, ) ),
                    onPressed: () {
                      setState(() {
                        selectedItem = null;
                        addItem = "yes";
                        // load the data stored in repository
                        AirplaneRepository.loadData().then((_) {
                          _controllerType.text = AirplaneRepository.type;
                          _controllerNumOfPassenger.text = AirplaneRepository.numOfPassenger;
                          _controllerMaxSpeed.text = AirplaneRepository.maxSpeed;
                          _controllerFlyDistance.text = AirplaneRepository.flyDistance;
                        });
                      });
                    } ),
              ]),
            ),
          ],
          )
      ),
    );
  }




  /// Builds the UI for adding a new airplane.
  ///
  /// This method returns a Scaffold widget that contains the UI elements
  /// for adding a new airplane and managing user interactions.
  Widget AirplaneAddPage() {

    return Scaffold(
      // Set the background color of the Scaffold
      backgroundColor: Colors.purple[50]?.withOpacity(0.5),

      // Center the content of the Scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the title of the page
            Text(AppLocalizations.of(context)!.translate('Add_New_Airplane')!, style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold, ),),
            // Add some space below the title
            const SizedBox(height: 40),

            // TextField for airplane type
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerType,
                decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.translate('Airplane_Type')!,
                ))),

            // TextField for number of passengers
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerNumOfPassenger,
                decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.translate('Airplane_Number_Of_Passenger')!,
                ))),

            // TextField for maximum speed
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerMaxSpeed,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.translate('Airplane_Max_Speed')!
                ))),

            // TextField for flying distance
            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerFlyDistance,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.translate('Airplane_Fly_Distance')!
                ))),

            // Add some space below the text fields
            const SizedBox(height: 50),

            // ElevatedButton for submitting the new airplane
            ElevatedButton( onPressed: (){
              // Show a confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.translate('Add_Airplane')!),
                    content: Text(AppLocalizations.of(context)!.translate('Want_add_airplane')!),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.translate('No')!),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                          child: Text(AppLocalizations.of(context)!.translate('Yes')!),
                          onPressed: buttonClicked
                      ),
                    ],
                  );
                },
              );
            },
              child:  Text(AppLocalizations.of(context)!.translate('Submit_New_Airplane')!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )),  ),
          ],
        ),
      ),
    );

  }



  /// Validates the input fields.
  ///
  /// This method checks if all the input fields are filled.
  /// Returns true if all fields have values, otherwise false.
  bool validateFields() {
    if (_controllerType.text.isEmpty ||
        _controllerNumOfPassenger.text.isEmpty ||
        _controllerMaxSpeed.text.isEmpty ||
        _controllerFlyDistance.text.isEmpty) {
      // One or more fields are empty
      return false;
    }
    // All fields have values
    return true;
  }



  /// Handles the button click event.
  ///
  /// This method is called when the submit button is clicked.
  /// It validates the input fields, stores the data in the repository,
  /// and updates the UI accordingly.
  void buttonClicked() async {
    // Check if all fields are filled
    if (validateFields()) {
      //store the data in repository
      AirplaneRepository.type = _controllerType.value.text;
      AirplaneRepository.numOfPassenger = _controllerNumOfPassenger.value.text;
      AirplaneRepository.maxSpeed = _controllerMaxSpeed.value.text;
      AirplaneRepository.flyDistance = _controllerFlyDistance.value.text;
      await AirplaneRepository.saveData();
      // Parse the data
      var inputType = _controllerType.value.text;
      var inputNumOfPassenger = _controllerNumOfPassenger.value.text;
      var  numberOfPassengers = int.parse(inputNumOfPassenger); // Convert to an int to perform numeric operations
      var inputMaxSpeed =  _controllerMaxSpeed.value.text;
      var maxSpeed = double.parse(inputMaxSpeed); // Convert to an int to perform numeric operations
      var inputFlyDistance =  _controllerFlyDistance.value.text;
      var flyDistance = double.parse(inputFlyDistance); // Convert to an int to perform numeric operations

      setState(() {
        // Insert the new airplane into the database
        var newItem = AirplaneItem(AirplaneItem.ID++, inputType, numberOfPassengers, maxSpeed, flyDistance);
        myDAO.insertAirplane(newItem);
        // Add the new airplane to the list
        airplane.add(newItem);
      });

      // clear the text field
      _controllerType.text = "";
      _controllerNumOfPassenger.text = "";
      _controllerMaxSpeed.text = "";
      _controllerFlyDistance.text = "";
      addItem = "";
      // Close the current page
      Navigator.of(context).pop();
      // Show a snackbar to indicate that the new airplane has been added
      var snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.translate('New_Airplane_Added')!),
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
            title: Text(AppLocalizations.of(context)!.translate('Error')!),
            content: Text(AppLocalizations.of(context)!.translate('Airplane_fields_required')!),
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
  }




  /// Builds the UI for showing details of an existing airplane.
  ///
  /// This method returns a Scaffold widget if one airplane item is selected, which contains the UI elements
  /// for showing details of an existing airplane and managing user interactions.
  Widget DetailsPage() {
    // Check if an item is selected
    if (selectedItem == null) {
      return Text(" ");
    }
    else {
      return Scaffold(
          backgroundColor: Colors.purple[50]?.withOpacity(0.5),
          body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Display the details of the airplane
                  Text(AppLocalizations.of(context)!.translate('Details_of_Airplane')!, style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold, ),),
                  const SizedBox(height: 40),

                  // TextField for Airplane Type
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerType,
                      decoration: InputDecoration(
                        hintText:"Type here",
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.translate('Airplane_Type')!,
                      ))),

                  // TextField for Number of Passengers
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerNumOfPassenger,
                      decoration: InputDecoration(
                          hintText:"Type here",
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.translate('Airplane_Number_Of_Passenger')!
                      ))),

                  // TextField for Maximum Speed
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerMaxSpeed,
                      decoration: InputDecoration(
                          hintText:"Type here",
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.translate('Airplane_Max_Speed')!
                      ))),

                  // TextField for Flying Distance
                  Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
                  TextField(controller: _controllerFlyDistance,
                      decoration: InputDecoration(
                          hintText:"Type here",
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.translate('Airplane_Fly_Distance')!
                      ))),

                  const SizedBox(height: 50),

                  // Row for Update and Delete buttons
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Update button
                        ElevatedButton( onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.translate('Update_Airplane')!),
                                content: Text(AppLocalizations.of(context)!.translate('Want_update_airplane')!),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.translate('No')!),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                      child: Text(AppLocalizations.of(context)!.translate('Yes')!),
                                      onPressed: updateClicked
                                  ),
                                ],
                              );
                            },
                          );
                        }, child:  Text(AppLocalizations.of(context)!.translate('Update')!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, ))  ),

                        SizedBox(width: 20),

                        // Delete button
                        ElevatedButton(onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.translate('Delete')!),
                                content: Text(AppLocalizations.of(context)!.translate('Want_delete_airplane')!),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.translate('No')!),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.translate('Yes')!),
                                    onPressed: () {
                                      setState(() {
                                        // delete from the database first, then delete the list
                                        myDAO.deleteAirplane(selectedItem!).then((_) {
                                          // Once the item is deleted from the database,  delete the list
                                          setState(() {
                                            // Remove the item from the list
                                            airplane.removeWhere((item) => item.id == selectedItem!.id);
                                            // Reset selectedItem to null
                                            selectedItem = null;
                                          });
                                        });
                                      });
                                      Navigator.of(context).pop(); // Close the dialog

                                      // show a snackbar if the delete the item
                                      var snackBar = SnackBar(
                                        content: Text(AppLocalizations.of(context)!.translate('Airplane_deleted')!),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }, child:  Text(AppLocalizations.of(context)!.translate('Delete')!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )))
                      ]
                  ),
                ],
              )
          )
      );
    }
  }


  /// Function to handle the update click event
  Future<void> updateClicked () async {
    // Update the existing item
    var updatedItem = AirplaneItem(
      selectedItem!.id,
      _controllerType.value.text,
      int.parse(_controllerNumOfPassenger.value.text),
      double.parse(_controllerMaxSpeed.value.text),
      double.parse(_controllerFlyDistance.value.text),
    );
    await myDAO.updateAirplane(updatedItem);
    // Update the item in the list
    int index = airplane.indexWhere((item) => item.id == selectedItem!.id);
    setState(() {
      airplane[index] = updatedItem;
    });
    // clear the text field
    _controllerType.text = "";
    _controllerNumOfPassenger.text = "";
    _controllerMaxSpeed.text = "";
    _controllerFlyDistance.text = "";

    selectedItem = null;

    Navigator.of(context).pop();

    // show a snackbar if the delete the item
    var snackBar = SnackBar(
      content: Text(AppLocalizations.of(context)!.translate('Airplane_updated')!),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }




  /// Widget to handle responsive layout
  Widget ResponsiveLayout(){
    // Get the size of the screen
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // Check if the device is in landscape mode and width is greater than 720
    if ((width>height) && (width > 720))
    {// Check if no item is selected and no item is being added
      if (selectedItem == null && addItem == "") {
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: Text(" "), ),]);
      }// Check if no item is selected and an item is being added
      else if (selectedItem == null && addItem == "yes"){
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: AirplaneAddPage(), ),]);
      }// Check if an item is selected and no item is being added
      else if (selectedItem != null && addItem == "") {
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: DetailsPage(),),]);
      }
      else return  Text(" ");
    }

    // Portrait mode
    else
    {// Check if no item is selected and no item is being added
      if (selectedItem == null && addItem == "")
      {
        return AirplaneList();
      }  // Check if no item is selected and an item is being added
      else if (selectedItem == null && addItem == "yes") {
        return AirplaneAddPage();
      }// Check if an item is selected and no item is being added
      else if (selectedItem != null && addItem == "") {
        return DetailsPage();
      }
      else return Text(" ");
    }
  }



  /// Function to show custom dialog based on the selected value
  void showCustomDialog(BuildContext context, String value) {
    String dialogTitle;
    Widget dialogContent;
    // Determine the dialog title and content based on the value
    switch (value) {
      case 'View':
        dialogTitle = AppLocalizations.of(context)!.translate('How_view_Airplane')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('How_view_Airplane_detail')!);
        break;
      case 'Add':
        dialogTitle = AppLocalizations.of(context)!.translate('How_add_Airplane')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('How_add_Airplane_detail')!);
        break;
      case 'Update':
        dialogTitle = AppLocalizations.of(context)!.translate('How_update_Airplane')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('How_update_Airplane_detail')!);
        break;
      case 'Delete':
        dialogTitle = AppLocalizations.of(context)!.translate('How_delete_Airplane')!;
        dialogContent = Text(AppLocalizations.of(context)!.translate('How_delete_Airplane_detail')!);
        break;
      default:
        dialogTitle = 'Unknown';
        dialogContent = Text('No information available.');
    }
    // Show the dialog
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.translate('Airplane')!, style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, ) ),
          actions: [
            // Button to switch to English
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("en", "CA") ); }, child:Text("English", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, ))),
            // Button to switch to Chinese
            TextButton(onPressed: () {MyApp.setLocale(context, Locale("zh", "CH") );  }, child:Text("中文", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, ))),
            // Button to clear the selected item and add item
            TextButton(onPressed: () {
              setState(() {
                addItem = "";
                selectedItem = null;
              });
            },
              child:Text(AppLocalizations.of(context)!.translate('Clear')!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )),
            ),
            SizedBox(width: 20),

            // Popup menu button for help options
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Handle the menu item action here
                showCustomDialog(context, value); // Example action: print the selected value
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'View',
                  child: Text(AppLocalizations.of(context)!.translate('How_view_Airplane')!),
                ),
                PopupMenuItem<String>(
                  value: 'Add',
                  child: Text(AppLocalizations.of(context)!.translate('How_add_Airplane')!),
                ),
                PopupMenuItem<String>(
                  value: 'Update',
                  child: Text(AppLocalizations.of(context)!.translate('How_update_Airplane')!),
                ),
                PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text(AppLocalizations.of(context)!.translate('How_delete_Airplane')!),
                ),
              ],
              child: Text(AppLocalizations.of(context)!.translate('Help')!, style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
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

