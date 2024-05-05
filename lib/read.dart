import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class CsvReaderPage extends StatefulWidget {
  @override
  _CsvReaderPageState createState() => _CsvReaderPageState();
}

class _CsvReaderPageState extends State<CsvReaderPage> {



  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    loadCsvData();
  }

  Future<void> loadCsvData() async {
    // Load CSV file from assets
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/farmdata.csv');
    // File file = File('${widget.directory.path}/farmdata.csv');
    String csvString = await file.readAsString();
    print(csvString);

    // Parse CSV data with correct row separator
    List<List<dynamic>> parsedCsv = const CsvToListConverter(eol: '\n').convert(csvString);

    setState(() {
      csvData = parsedCsv;
    });
  }

  void deleteRow(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/farmdata.csv');
    csvData.removeAt(index);
    List<List<String>> csvRows = csvData.map((row) => row.map((cell) => cell.toString()).toList()).toList();
    String csvContent = const ListToCsvConverter().convert(csvRows);
    await file.writeAsString(csvContent);

    //DEBUG READFOR DELETE
    String csvString = await file.readAsString();
    print("Deleted. Currently CSV is: ");
    print(csvString);
    setState(() {});


  }
  //COLOR STYLES FOR THIS PAGE

  final LinearGradient _buttonGradient = LinearGradient(
    colors: [Colors.deepPurpleAccent[700]!,Colors.tealAccent[700]!, Colors.lightGreenAccent[700]!], // Adjust colors as desired
    // Adjust colors as desired
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final TextStyle _wTextStyle = const TextStyle(color: Colors.white, fontSize: 18.0);
  final TextStyle _headStyle = const TextStyle(color: Colors.white, fontSize: 24.0,fontWeight: FontWeight.w700);
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
      body: csvData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Name', style: _headStyle),
                Text('X', style: _headStyle),
                Text('Y', style: _headStyle),
                Text('Sector', style: _headStyle),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: csvData.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Dismissible(
                      key: Key(csvData[index].toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          deleteRow(index);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(csvData[index][0].toString(), style: _wTextStyle),
                          Text(csvData[index][1].toString(), style: _wTextStyle),
                          Text(csvData[index][2].toString(), style: _wTextStyle),
                          Text(csvData[index][3].toString(), style: _wTextStyle),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white,height:35), // Divider for each row
                  ],
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
