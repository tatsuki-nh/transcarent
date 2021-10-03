
// Representation of response JSON
class SearchResult {
  // "search_metadata": { ... },
  // "search_parameters": { ... },
  // "search_information": { ... },
  // "suggested_searches": [ {...}, ...],

  // "images_results": [ {...}, ...],
  final List<ImageResult> imageResults;

  // constructor
  SearchResult(this.imageResults);

  // named constructor to deserialize from JSON
  SearchResult.fromJson(Map<String, dynamic> json)
      : imageResults = json['images_results'].map<ImageResult>((i) => new ImageResult.fromJson(i)).toList()
    ;
}

// Representation of single map in images_results
class ImageResult {
  //"position": 1,
  final int position;

  //"thumbnail": "https://serpapi.com/searches/6154b01c9bddf7686921d87c/images/4d8d2a7c177beeb1f545a0281a2ac7b1f36a6e4e08ecc342f47407938b4bdbe9.jpeg",
  final String thumbnail;

  // "source": "applesfromny.com",
  final String source;

  // "title": "SnapDragon® - New York Apple Association",
  final String title;

  // "link": "https://www.applesfromny.com/varieties/snapdragon/",
  final String link;

  // "original": "https://www.applesfromny.com/wp-content/uploads/2020/06/SnapdragonNEW.png",
  final String original;

  // "is_product": false, TBD only first page includes this property?
  final bool? isProduct;

  // constructor
  ImageResult(this.position, this.thumbnail, this.source, this.title, this.link, this.original, this.isProduct);

  // named constructor to deserialize from JSON
  ImageResult.fromJson(Map<String, dynamic> json)
      : position = json['position'],
        thumbnail = json['thumbnail'],
        source = json['source'],
        title = json['title'],
        link = json['link'],
        original = json['original'],
        isProduct = json['is_product'];
  }