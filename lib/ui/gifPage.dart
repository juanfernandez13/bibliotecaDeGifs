import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {

  final Map _gif;
  GifPage(this._gif);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(_gif['title']),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_gif["images"]["fixed_height"]["url"]);
              },
            )
          ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Flexible(child: Image.network(_gif["images"]["fixed_height"]["url"]))
          ],),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(_gif['title'],style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}
