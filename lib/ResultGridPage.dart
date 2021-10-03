import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transcarent/SearchResult.dart';
import 'package:transcarent/DetailPage.dart';

class ResultGridPage extends StatefulWidget {
  // constructor
  ResultGridPage({Key? key, required this.searchWords}) : super(key: key);

  // Search words
  String searchWords;

  @override
  State<StatefulWidget> createState() {
    return ResultGridPageState();
  }
}

class ResultGridPageState extends State<ResultGridPage> {
  // Observe response of search request
  // late Future<SearchResult> searchResult;
  late ScrollController scrollController;
  final List<ImageResult> images = [];
  int pageCount = 1;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // fetch first page
    addItemIntoLisT(pageCount);

    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent <= scrollController.position.pixels) {
          pageCount = pageCount + 1;
          addItemIntoLisT(pageCount);
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Search "${widget.searchWords}"'),
      )
      ,
      // Uses builder to construct grid view
      body: GridView.builder(
        itemCount: images.length,
        // listening scroll event
        controller: scrollController,
        // Align three grids in single row
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        )
        ,
        itemBuilder: (BuildContext context, int index) {
          // Create grid view cell at indicated position
          return GestureDetector(
            child: SizedBox.expand(
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 20),
                  child: Image.network(
                    images[index].thumbnail,
                    fit: BoxFit.cover,
                  )
              ),
            ),
            // handle tap event on the grid cell
            onTap: () {
              // push detail page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(image: images[index],)),
              );
            }
          );
        },
      ),
    );
  }

  void addItemIntoLisT(int pageCount) {
    Future<SearchResult> searchResult = searchImages(pageCount-1, widget.searchWords)
      ..then((f) {
        setState(() {
          this.images.addAll(f.imageResults);
        });
      });
  }
}


// Returns an observer of asynchronous request operation
Future<SearchResult> searchImages(int page, String searchWords) async {
  String qparam = Uri.encodeComponent(searchWords.trim());
print(qparam);
  // final response = await http.get(Uri.parse('https://www.nrby.com'));
  final response = await http.get(Uri.parse('http://192.168.1.21:9000/search.json?q=$qparam&tbm=isch&ijn=$page&api_key=9432e462331348ece728502579d67164b07030f89d41c94c8047cdc406112d09'));
  if (response.statusCode == 200) {
    print(response.body);
    return SearchResult.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Failed to search images');
  }
}
