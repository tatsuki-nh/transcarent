
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transcarent/SearchResult.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gallery_saver/gallery_saver.dart';

class DetailPage extends StatelessWidget {
  // constructor
  DetailPage({Key? key, required this.image}) : super(key: key);

  final ImageResult image;

  @override
  Widget build(BuildContext context) {
    print(image.original);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: () {
              GallerySaver.saveImage(image.original)
                  .then((success) {
                    print(success);
              });
            }
          ),
        ],
      ),
      body: SizedBox.expand(child:
      Container(
        color: Colors.black,
        child: Column(
          children: [
            // Show original image on white background
            Container(
              color: Colors.white,
              child: CachedNetworkImage(
                imageUrl: image.original,
                fit: BoxFit.contain,
                placeholder: (context, url) =>  CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red,),
              ),
            ),
            SizedBox(height: 5),
            // Show image source
            Container(
              width: double.infinity,
              child: Text(image.source, textScaleFactor: 1.2, textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
            ),
            SizedBox(height: 15),
            // Show title
            Text(image.title, textScaleFactor: 1.5, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                Text(image.link),
            ElevatedButton(
              child: const Text('Visit'),
              // color: Colors.blue,
              // textColor: Colors.white,
              onPressed: image.link.isNotEmpty? () {
                _launchURL();
              } : null,
            )
          ],
        ),
      ),
      ),
    );
  }

  _launchURL() async {
    if (await canLaunch(image.link)) {
      await launch(image.link);
    } else {
      throw 'Could not launch';
    }
  }
}