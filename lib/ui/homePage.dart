import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shimmer/shimmer.dart';


import 'gifPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == '')
      response = await http.get(
          Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=eSl9fZefglgGXyBGTB0D4rHmFj57bmZt&limit=50&rating=g"));
    else
      response = await http.get(
          Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&q=$_search&limit=19&offset=$_offset&rating=G&lang=en"));

    return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
                labelText: 'Pesquise seu Gif!',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    ),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 1.0,
                  ),
                ),

              ),
              textAlign: TextAlign.start,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 19;
                });
              },
            ),
          ),

          Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );

                      default:
                        if (snapshot.hasError)
                        return Container(
                          color: Colors.red,
                        );
                      else
                          return _gifTable(context, snapshot);
                    }
                  }))
        ],
      ),
    );
  }

  int _gifCount(List gifs){

    if(_search == null || _search == '') return gifs.length;
    else return gifs.length + 1;

  }

  Widget _gifTable(BuildContext context, AsyncSnapshot snapshot){
    return RawScrollbar(
      isAlwaysShown: true,
        thumbColor: Colors.green,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
            ),
            itemCount: _gifCount(snapshot.data['data']),
            itemBuilder: (ctx, index){
              if(_search == null || index < snapshot.data["data"].length)
                return GestureDetector(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GifPage(snapshot.data["data"][index])));
                  },
                  onLongPress: (){
                    Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
                  },
                );

              else
                return GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),


                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              );
            }) );
  }


}

