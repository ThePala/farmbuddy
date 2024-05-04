import 'package:farmbuddy/read.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';


class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmBuddy Input',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.green
        ),
        primarySwatch: Colors.blue, // Maintain primary color
        fontFamily: 'SFUI', // Maintain font family
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.white38),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: InputPage(),
      ),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController xCoordinateController = TextEditingController();
  final TextEditingController yCoordinateController = TextEditingController();
  final TextEditingController sectorNumberController = TextEditingController();

  //COLOR and SIZE DEFINITIONS
  final TextStyle _wTextStyle = const TextStyle(color: Colors.white, fontSize: 18.0);
  final ButtonStyle _bStyle = ButtonStyle(
    minimumSize: MaterialStateProperty.all<Size>(const Size(200, 70)), // Define the minimum size of the button
    maximumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(fontSize: 17.5),
    ),
  );

  Future<void> _submitData() async {
    try {
      String name = nameController.text;
      String xCoordinate = xCoordinateController.text;
      String yCoordinate = yCoordinateController.text;
      String sectorNumber = sectorNumberController.text;

      // Create a list of values for a row
      List<String> rowData = [name, xCoordinate, yCoordinate, sectorNumber];

      // Create a CSV row by joining the values with commas
      String csvRow = rowData.join(',') + '\n';

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/farmdata.csv');

      if (!file.existsSync()) {
        await file.create();
      }

      // Append the data to the file
      await file.writeAsString(csvRow, mode: FileMode.append);

      // Clearing input fields
      nameController.clear();
      xCoordinateController.clear();
      yCoordinateController.clear();
      sectorNumberController.clear();

      print('Data successfully written to CSV file.');
    } catch (e) {
      print('Error writing to CSV file: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('FarmBuddy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  // Set text style for the input text
                  hintStyle: TextStyle(color: Colors.white),
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: _wTextStyle,
              ),
              SizedBox(height: 18.0),
              TextField(
                controller: xCoordinateController,
                decoration: const InputDecoration(
                  labelText: 'X Coordinate',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set text style for the input text
                  hintStyle: TextStyle(color: Colors.white),
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: yCoordinateController,
                decoration: const InputDecoration(
                  labelText: 'Y Coordinate',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set text style for the input text
                  hintStyle: TextStyle(color: Colors.white),
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: sectorNumberController,
                decoration: const InputDecoration(
                  labelText: 'Sector Number',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set text style for the input text
                  hintStyle: TextStyle(color: Colors.white),
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              SizedBox(height: 60.0),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
                style: _bStyle,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(style: _bStyle,
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CsvReaderPage()),
                );
              },
                  child: Text("Read CSV")
            ),
            ],
          ),
        ),
      ),
    );
  }
}
