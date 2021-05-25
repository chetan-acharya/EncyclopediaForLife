import 'dart:math';
import 'package:encyclopedia_for_life/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        primarySwatch: Colors.blue,
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
  // tells if the screen is in refreshing state or not
  bool isRefreshing = false;
  //get a random id to show up on dashboard for random fact
  var randomId = Random().nextInt(50000);

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

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      centerTitle: true,
      title: Text(widget.title),
    );
    return Scaffold(
      // appBar: appBar,
      body: Container(
        color: Color(0xFF8ab6d6),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(
        //         "https://cdn.statically.io/img/wallpapercave.com/wp/wp4670912.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: RefreshIndicator(
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
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    appBar.preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getSearchBarWidget(),
                      ],
                    ),
                    getDetailAreaWidget(),
                    getPullToRefreshTextWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Flexible getPullToRefreshTextWidget() {
    return Flexible(
      flex: 1,
      child: Text(
        'Pull from the top to discover more species',
        style: GoogleFonts.yanoneKaffeesatz(
            fontStyle: FontStyle.italic,
            //hack to show and hide when seach bar focus change
            fontSize: isAutoCompleteFocused || isRefreshing ? 0 : 18),
      ),
    );
  }

  Flexible getDetailAreaWidget() {
    return Flexible(
      flex: 10,
      child: DetailPage(
        //key is important so that this widget rebuilds when random id changes
        key: Key(randomId.toString()),
        pageId: randomId.toString(),
      ),
    );
  }

  Container getSearchBarWidget() {
    return Container(
      width: 300,
      height: 50,
      child: AutocompleteSearchBar(
        //callback is recieved when focus changes of search bar
        onFocusChange: onAutoCompleteFocusChange,
      ),
      margin: const EdgeInsets.only(top: 15, bottom: 15),
    );
  }
}
