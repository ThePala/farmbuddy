import 'package:farmbuddy/read.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';



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
          backgroundColor: Color(0x14BBBBBB),
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white70),
          floatingLabelStyle: TextStyle(color: Colors.white70),
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
  final LinearGradient _buttonGradient = LinearGradient(
    colors: [Colors.deepPurpleAccent[700]!,Colors.tealAccent[700]!, Colors.lightGreenAccent[700]!], // Adjust colors as desired
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final LinearGradient _buttonGradient2 = const LinearGradient(
    colors: [Colors.white38,Colors.grey, Colors.white38],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [0.2,0.5,1]
  );

  final TextStyle _wTextStyle = const TextStyle(color: Colors.white, fontSize: 18.0);
  final ButtonStyle _bStyle = ButtonStyle(
    minimumSize: MaterialStateProperty.all<Size>(const Size(200, 70)), // Define the minimum size of the button
    maximumSize: MaterialStateProperty.all<Size>(const Size(300, 70)),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white10),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(fontSize: 17.5),
    ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust the value for desired roundness
        ),
      )
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
        title: ShaderMask(
          shaderCallback: (bounds) =>
            _buttonGradient.createShader(bounds),
            child: const Text('FarmHelper',style: TextStyle(color: Colors.white))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration:  const InputDecoration(
                  labelText: 'Name',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                style: _wTextStyle,
              ),
              const SizedBox(height: 18.0),
              TextField(
                controller: xCoordinateController,
                decoration:  const InputDecoration(
                  labelText: 'X Coordinate',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: yCoordinateController,
                decoration:  const InputDecoration(
                  labelText: 'Y Coordinate',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: sectorNumberController,
                decoration:  const InputDecoration(
                  labelText: 'Sector Number',floatingLabelAlignment: FloatingLabelAlignment.center,
                  // Set cursor color
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: _wTextStyle,
              ),
              const SizedBox(height: 60.0),
              ElevatedButton.icon(
                icon: ShaderMask(shaderCallback: (bounds) =>
                    _buttonGradient.createShader(bounds),child: const Icon(Icons.add_box)),
                onPressed: _submitData,
                style: _bStyle,
                label: ShaderMask(
                    shaderCallback: (bounds) =>
                        _buttonGradient2.createShader(bounds),
                    child: const Text('Submit',style: TextStyle(color: Colors.white))),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(style: _bStyle,
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CsvReaderPage()),
                );
              },
                  icon: ShaderMask(shaderCallback: (bounds) =>
                      _buttonGradient.createShader(bounds),child: const Icon(Icons.ac_unit_rounded)),
                  label: ShaderMask(
                      shaderCallback: (bounds) =>
                          _buttonGradient2.createShader(bounds),
                      child: const Text('Display',style: TextStyle(color: Colors.white))),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
