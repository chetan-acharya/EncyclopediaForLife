import 'dart:math';

import 'package:encyclopedia_for_life/detail_page.dart';
import 'package:flutter/material.dart';

import 'Widgets/autocomplete_search_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encyclopedia For Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Encyclopedia For Life'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAutoCompleteFocused = false;
  void onAutoCompleteFocusChange(bool isFocused) {
    if (isFocused) {
      setState(() {
        isAutoCompleteFocused = isFocused;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          isAutoCompleteFocused = isFocused;
        });
      });
    }
  }

  var randomId = Random().nextInt(35000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
            () {
              setState(() {
                randomId = Random().nextInt(35000);
              });
            },
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  child: AutocompleteSearchBar(
                    onFocusChange: onAutoCompleteFocusChange,
                  ),
                  margin: const EdgeInsets.all(15),
                ),
                Text('Random Fact',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                  size: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: isAutoCompleteFocused ? 0 : 600,
                    child: DetailPage(
                      key: UniqueKey(),
                      pageId: randomId.toString(),
                    )),
                Text(
                  'Pull to refresh',
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
                // if (!isAutoCompleteFocused)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
