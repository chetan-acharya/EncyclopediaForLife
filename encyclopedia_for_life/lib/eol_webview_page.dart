import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EOLWebView extends StatefulWidget {
  @override
  _EOLWebViewState createState() => _EOLWebViewState();
  String pageId;
  EOLWebView(this.pageId);
}

class _EOLWebViewState extends State<EOLWebView> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarTextStyle: Theme.of(context).appBarTheme.toolbarTextStyle,
      ),
      body: Stack(children: <Widget>[
        WebView(
          initialUrl: 'https://eol.org/pages/' + widget.pageId,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(),
      ]),
    );
  }
}
