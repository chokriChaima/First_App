import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart'; 
class SampleJson extends StatefulWidget {
  const SampleJson({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SampleJson> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    // rootBundle comes from flutter/services.dart
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Json Code Example',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal : 80.0),
                child:  Text('Load Data',style: TextStyle(fontSize: 16),),
              ),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(_items[index]["id"]),
                            title: Text(_items[index]["name"]),
                            subtitle: Text(_items[index]["description"]),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}