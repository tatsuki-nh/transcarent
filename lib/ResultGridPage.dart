
import 'package:flutter/material.dart';
import 'package:transcarent/SearchBloc.dart';
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
  late ScrollController _scrollController;
  late SearchBloc _searchBloc;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(widget.searchWords);
    // fetch first page
    _searchBloc.nextPage();

    // listen scroll event to notice hit to end of scroll position.
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent <= _scrollController.position.pixels) {
          _searchBloc.nextPage();
        }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Search "${widget.searchWords}"'),
      )
      ,
      // Uses builder to construct grid view
      body: StreamBuilder(
        stream: _searchBloc.results,
        builder: (content, AsyncSnapshot<List<ImageResult>> snapshot) {
          return buildGridView(snapshot);
        }
      ),
    );
  }

  Widget buildGridView(AsyncSnapshot<List<ImageResult>> snapshot) {
    var images = snapshot.data;

    return GridView.builder(
      itemCount: images!.length,
      // listening scroll event
      controller: _scrollController,
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
    );
  }
}
