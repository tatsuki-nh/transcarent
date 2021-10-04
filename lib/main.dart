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
  final _textController = TextEditingController();
  bool _hasSearchWords = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Enter Search Words",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _textController.clear,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // ignore whitespace then check to see if there is valid words.
                  _hasSearchWords = value.replaceAll(' ', '').isNotEmpty;
                });
              }
            )
            ,
            SizedBox(height: 30.0)
            ,
            ElevatedButton(
              child: const Text('Search'),
              // set null to disable button if text field is empty
              onPressed: _hasSearchWords? () {
                // push search result page
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultGridPage(searchWords: _textController.text)),
                );
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}
