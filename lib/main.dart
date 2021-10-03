import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:transcarent/ResultGridPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  bool hasSearchWords = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Images'),
      )
      ,
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Enter Search Words",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: textController.clear,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // ignore whitespace then check to see if there is valid words.
                  hasSearchWords = value.replaceAll(' ', '').isNotEmpty;
                });
              }
            )
            ,
            SizedBox(height: 30.0)
            ,
            ElevatedButton(
              child: const Text('Search'),
              // set null to disable button if text field is empty
              onPressed: hasSearchWords? () {
                // push search result page
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultGridPage(searchWords: textController.text)),
                );
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}
