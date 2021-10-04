import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:transcarent/SearchResult.dart';

class SearchBloc {
  final _actionController = StreamController<void>();
  // call this to fetch next page of search result.
  nextPage() {
    if (!_actionController.isClosed) {
      _actionController.sink.add(null);
    }
  }

  final _resultController = StreamController<List<ImageResult>>();
  Stream<List<ImageResult>> get results => _resultController.stream;

  String searchWords;
  int _pageCount = 0;
  // List of image data.
  List<ImageResult> _images = [];

  // constructor
  SearchBloc(this.searchWords) {
    _actionController.stream.listen((_) {
      _listenNextPageRequest();
    });
  }

  // cleanup stream controllers
  void dispose() {
    print('disposed BLOC');
    _actionController.close();
    _resultController.close();
  }

  void _listenNextPageRequest() async {
    // Retrieve page.
    try {
      await searchImages()
          .then((f) {
        // increase page count for next request.
        _pageCount++;
        // append result images to the list.
        _images.addAll(f);
        // let the listener know that new images are added.
        _resultController.sink.add(_images);
      });
    } on FormatException catch(ex) {
      print("exception + ${ex.toString()}");
      if (ex.source == 404) {
        // No more page - close the controller so that it does not receive further request.
        //TODO: I am not sure real server returns what error code when it reaches end of result pages.
        // This is just for error handling in debug environment with WireMock.
        _actionController.close();
      }
    } catch (error) {
      print(error);
      // ignore exception for now
    }
  }

  // Returns an observer of asynchronous request operation
  Future<List<ImageResult>> searchImages() async {
    String qparam = Uri.encodeComponent(searchWords.trim());
    print(qparam);
    // final response = await http.get(Uri.parse('http://192.168.1.21:9000/search.json?q=$qparam&tbm=isch&ijn=$_pageCount&api_key=9432e462331348ece728502579d67164b07030f89d41c94c8047cdc406112d09'));
    final response = await http.get(Uri.parse('http://serpapi.com/search.json?q=$qparam&tbm=isch&ijn=$_pageCount&api_key=9432e462331348ece728502579d67164b07030f89d41c94c8047cdc406112d09'));
    if (response.statusCode == 200) {
      print(response.body);
      return SearchResult.fromJson(jsonDecode(response.body)).imageResults;
    }
    else {
      throw FormatException('Failed to get next page', response.statusCode);
    }
  }
}