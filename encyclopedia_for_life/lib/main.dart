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
//tells if search bar is focused or not
  bool isAutoCompleteFocused = false;

// method to the the status of isAutoCompleteFocused
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

// tells if the screen is in refreshing state or not
  bool isRefreshing = false;

//get a random id to show up on dashboard for random fact
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
          setState(() {
            isRefreshing = true;
            //get a new random id to get new data from API
            randomId = Random().nextInt(35000);
          });
          return Future.delayed(
            //duration is 3 seconds for the refresh icon on the top because the server
            //is taking generally this long to give response data
            Duration(seconds: 3),
            () {
              setState(() {
                isRefreshing = false;
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
                    //callback is recieved when focus changes of search bar
                    onFocusChange: onAutoCompleteFocusChange,
                  ),
                  margin: const EdgeInsets.all(15),
                ),
                Text('Random Fact',
                    style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            //hack to show and hide when seach bar focus change
                            isAutoCompleteFocused || isRefreshing ? 0 : 20)),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.purple,
                  //hack to show and hide when seach bar focus change
                  size: isAutoCompleteFocused || isRefreshing ? 0 : 20,
                ),
                SizedBox(
                    width: double.infinity,
                    //hack to show and hide when seach bar focus change
                    height: isAutoCompleteFocused ? 0 : 600,
                    child: DetailPage(
                      //key is important so that this widget rebuilds when random id changes
                      key: Key(randomId.toString()),
                      pageId: randomId.toString(),
                    )),
                Text(
                  'Pull to refresh',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      //hack to show and hide when seach bar focus change
                      fontSize: isAutoCompleteFocused || isRefreshing ? 0 : 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
