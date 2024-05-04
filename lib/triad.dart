//WORKING BUT NOT DELETE AND NOT LOOK GOOD
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
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
    //File file = File('${widget.directory.path}/farmdata.csv');
    String csvString = await file.readAsString();

    // Parse CSV data
    List<List<dynamic>> parsedCsv = const CsvToListConverter().convert(csvString);

    setState(() {
      csvData = parsedCsv;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Reader'),
      ),
      body: csvData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: csvData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(csvData[index].join(', ')),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Navigate to previous page
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}