
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'AirplaneDAO.dart';
import 'AirplaneDatabase.dart';
import 'AirplaneItem.dart';
import 'AirplaneRepository.dart';

class AirplanePage extends StatefulWidget { // stateful means has variables
  @override
  State<AirplanePage> createState() => AirplanePageState();
}



class AirplanePageState extends State<AirplanePage> {


  late TextEditingController _controllerType; // late means initialize later, but not null
  late TextEditingController _controllerNumOfPassenger;
  late TextEditingController _controllerMaxSpeed;
  late TextEditingController _controllerFlyDistance;


  /// create a DAO object
  late AirplaneDAO myDAO;

  List<AirplaneItem> airplane =  [] ; // empty array

  AirplaneItem? selectedItem = null;

  String addItem = "";


  @override
  void initState() {
    // initialize object, onloaded in HTML
    super.initState();


    _controllerType = TextEditingController();
    _controllerNumOfPassenger = TextEditingController();
    _controllerMaxSpeed = TextEditingController();
    _controllerFlyDistance = TextEditingController();



    // create the database
    // can not use the await inside the initState
    // final database = await $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build();
    $FloorAirplaneDatabase.databaseBuilder('airplane_database.db').build().then((database){
      myDAO = database.itemDao;

      // retrieve all items from DB, and add these to the list each time you restart the app
      myDAO.getAllItems().then ( (allItems) {
        setState(() {
          airplane.addAll(allItems);
        });
      } );

    });

  }



  @override
  void dispose() { //unloading the page
    super.dispose();
    _controllerType.dispose(); //delete memory of _controller
    _controllerNumOfPassenger.dispose();
    _controllerMaxSpeed.dispose();
    _controllerFlyDistance.dispose();

  }





/// This function is
  Widget AirplaneList() {

    return Scaffold(

      backgroundColor: Colors.deepPurple[50]?.withOpacity(0.5),

       body: Center(
        child: Column( mainAxisAlignment: MainAxisAlignment.center, children:<Widget>[
          const SizedBox(height: 90),

          Text("Current Airplane List: ", style: TextStyle(fontSize: 24, color: Colors.purple, fontWeight: FontWeight.bold, ),),

          const SizedBox(height: 20),

      // ListView
             Expanded(
                child: airplane.isEmpty
          // Display this when list is empty
              ?
                 const Align(
                 alignment: Alignment.center,
                   child: Padding(
                    padding: EdgeInsets.only(top: 20.0), // Add some padding at the top
                     child: Text('There are no items in the list', style: TextStyle(fontSize: 18, color: Colors.indigoAccent,),),
            ),
          )

          // display the ListView when has some item
                 : ListView.builder(
                    itemCount: airplane.length,
                    itemBuilder: (context, rowNum) {
                      return  Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
                          child:  GestureDetector(child:
                           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Text("Airplane Type ${rowNum+1}: ", style: TextStyle(fontSize: 18, color: Colors.purple ),),
                            Text( airplane[rowNum].type, style: TextStyle(fontSize: 18, color: Colors.purple ),),
                      ]
                  ),
                      //onDoubleTap(){}; onLongPress(){}; onHorizontalDragUpdate(){}
                      onTap: () {
                        setState(() {
                          addItem = "";
                          selectedItem = airplane[rowNum];

                            // load the data stored in database
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

           Container(
             padding: EdgeInsets.all(30),
             child: Row( mainAxisAlignment: MainAxisAlignment.center, children:[
               ElevatedButton( child: Text("Add Airplane",  style: TextStyle(fontSize: 15, color:Colors.purple, fontWeight: FontWeight.bold, ) ),
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





  Widget AirplaneAddPage() {

    return Scaffold(

      backgroundColor: Colors.purple[50]?.withOpacity(0.5),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

             Text("Add New Airplane: ", style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold, ),),

            const SizedBox(height: 40),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerType,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Airplane Type"
                ))),

            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerNumOfPassenger,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Airplane Number Of Passenger"
                ))),


            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerMaxSpeed,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Airplane Max Speed"
                ))),


            Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
            TextField(controller: _controllerFlyDistance,
                decoration: InputDecoration(
                    hintText:"Type here",
                    border: OutlineInputBorder(),
                    labelText: "Airplane Fly Distance"
                ))),

            const SizedBox(height: 50),

            ElevatedButton( onPressed: (){

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Airplane'),
                    content: Text('Do you want to add this airplane?'),
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
                child:  Text("Submit New Airplane", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )),  ),

          ],
        ),
      ),
    );

  }


  // check if there is data
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



  //This function gets run when you click the button
  void buttonClicked() async {

    // store data in the database
   if (validateFields()) {

     //store the data in repository
     AirplaneRepository.type = _controllerType.value.text;
     AirplaneRepository.numOfPassenger = _controllerNumOfPassenger.value.text;
     AirplaneRepository.maxSpeed = _controllerMaxSpeed.value.text;
     AirplaneRepository.flyDistance = _controllerFlyDistance.value.text;

     await AirplaneRepository.saveData();

     // parse the data
     var inputType = _controllerType.value.text;

     var inputNumOfPassenger = _controllerNumOfPassenger.value.text;
     var  numberOfPassengers = int.parse(inputNumOfPassenger); // Convert to an int to perform numeric operations

     var inputMaxSpeed =  _controllerMaxSpeed.value.text;
     var maxSpeed = double.parse(inputMaxSpeed); // Convert to an int to perform numeric operations

     var inputFlyDistance =  _controllerFlyDistance.value.text;
     var flyDistance = double.parse(inputFlyDistance); // Convert to an int to perform numeric operations


     setState(() {
       // also insert the database
       var newItem = AirplaneItem(AirplaneItem.ID++, inputType, numberOfPassengers, maxSpeed, flyDistance);
       myDAO.insertAirplane(newItem);
       // add what you typed
       airplane.add(newItem);

     });

    // clear the text field
    _controllerType.text = "";
    _controllerNumOfPassenger.text = "";
    _controllerMaxSpeed.text = "";
    _controllerFlyDistance.text = "";

    addItem = "";

    Navigator.of(context).pop();

    // show a snackbar if the delete the item
    var snackBar = SnackBar(
      content: Text('The New Aiplane is Added!'),
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
           content: Text('All fields are required. Please fill them to proceed.'),
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








  Widget DetailsPage() {
    if (selectedItem == null) {
      return Text(" ");
    }
    else {
      return Scaffold(

        backgroundColor: Colors.purple[50]?.withOpacity(0.5),

        body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

            Text("Details of Airplane ${selectedItem!.type}", style: TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold, ),),

          const SizedBox(height: 40),


          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
          TextField(controller: _controllerType,
              decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: "Airplane Type",
              ))),


          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
          TextField(controller: _controllerNumOfPassenger,
              decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: "Airplane Number Of Passenger"
              ))),


          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
          TextField(controller: _controllerMaxSpeed,
              decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: "Airplane Max Speed"
              ))),


          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10), child:
          TextField(controller: _controllerFlyDistance,
              decoration: InputDecoration(
                  hintText:"Type here",
                  border: OutlineInputBorder(),
                  labelText: "Airplane Fly Distance"
              ))),

          const SizedBox(height: 50),


          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton( onPressed: (){

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update Airplane'),
                        content: Text('Do you want to update this airplane?'),
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


                }, child:  Text("Update", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, ))  ),

                SizedBox(width: 20),

                ElevatedButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Item'),
                        content: Text('Do you want to delete this item?'),
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
                                content: Text('The Aiplane is deleted!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);


                            },
                          ),
                        ],
                      );
                    },
                  );
                }, child:  Text("Delete", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )))

              ]
          ),
      ],
      )
    )
      );
    }
  }


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
      content: Text('The Aiplane is Updated!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);


  }





  Widget ResponsiveLayout(){

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width>height) && (width > 720))
    {
      if (selectedItem == null && addItem == "") {
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: Text(" "), ),]);
      }
      else if (selectedItem == null && addItem == "yes"){
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: AirplaneAddPage(), ),]);
      }
      else if (selectedItem != null && addItem == "") {
        return Row( children:[ Expanded( flex: 1, child: AirplaneList(),),
          Expanded(flex: 2, child: DetailsPage(),),]);
      }
      else return  Text(" ");
    }

    // portrait
    else
    {
      if (selectedItem == null && addItem == "")
      {
        return AirplaneList();
      }
      else if (selectedItem == null && addItem == "yes") {
        return AirplaneAddPage();
      }
      else if (selectedItem != null && addItem == "") {
        return DetailsPage();
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Airplane", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, ) ),
          actions: [
            TextButton(onPressed: () {
              setState(() {
                addItem = "";
                selectedItem = null;
              });
            },
                child:Text("Clear the Selected Item", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, )),
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
              child: Text("Help", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
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