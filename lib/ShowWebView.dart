import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowWebView extends StatelessWidget {
  String url;
  String title;
  ShowWebView(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 24.0,),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (val) {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

}