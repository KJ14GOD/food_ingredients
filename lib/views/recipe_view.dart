  import 'dart:async';
  import 'package:flutter/material.dart';
  import 'dart:io';
  import 'package:flutter/foundation.dart';
  import 'package:webview_flutter/webview_flutter.dart';
  class RecipeView extends StatefulWidget {

    final String postUrl;
    RecipeView({this.postUrl});

    @override
    _RecipeViewState createState() => _RecipeViewState();
  }

  class _RecipeViewState extends State<RecipeView> {

    String finalUrl;
    final Completer<WebViewController> _controller = Completer<WebViewController>();

    @override
    void initState() {
      if(widget.postUrl.contains("http://")){
        finalUrl = widget.postUrl.replaceAll("http://", "https://");
      }else{
        finalUrl = widget.postUrl;
      }
      super.initState();
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: Platform.isAndroid ? 60: 30, right: 24, left: 24, bottom: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xff213A50),
                        const Color(0xff071930),
                      ]
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: kIsWeb ? MainAxisAlignment.start :
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Kitchen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Khazana',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: WebView(
                    initialUrl: finalUrl,
                    onWebViewCreated: (WebViewController webViewController){
                      setState(() {
                        _controller.complete(webViewController);
                      });
                    }),
              )
            ],
          ),
        ),
      );
    }
  }