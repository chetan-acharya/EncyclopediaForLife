import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:encyclopedia_for_life/BackendService/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:encyclopedia_for_life/BackendService/backend_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.pageId, this.showAppBar: false}) : super(key: key);

  //pageId is the id of the item we are requesting the details from the API
  final String pageId;
  //show app bar
  final bool showAppBar;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<ItemDetailResult> _itemDetail;

  @override
  void initState() {
    super.initState();

    //getting item detail from the API
    //isRandom indicates if the page is dashboard with random data or detail page
    _itemDetail = BackendService.getInstance()
        .getDetail(widget.pageId, isRandom: !widget.showAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar() : null,
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
        child: FutureBuilder<ItemDetailResult>(
          future: _itemDetail, // a previously-obtained Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<ItemDetailResult> snapshot) {
            List<Widget> children;

            if (snapshot.hasData) {
              children = onSuccessDataWidget(snapshot);
            } else if (snapshot.hasError) {
              children = errorWidget();
            } else {
              children = loadingWidget();
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }

//this widget is called when API call is successful and we have some data to show
  List<Widget> onSuccessDataWidget(AsyncSnapshot<ItemDetailResult> snapshot) {
    return <Widget>[
      Flexible(
          flex: 2,
          child: CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 0.82,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
            ),
            items: snapshot.data.imageURLs.map((imageURL) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: CachedNetworkImage(
                      imageUrl: imageURL,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.black //Theme.of(context).accentColor,
                              ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => getPlaceholderWidget(),
                      errorWidget: (context, url, error) =>
                          getOnImageURLServerExceptionWidget(),
                    ),
                  );
                },
              );
            }).toList(),
          )),
      Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(
            snapshot.data.description,
            style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }

  Container getPlaceholderWidget() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor)),
    );
  }

  Container getOnImageURLServerExceptionWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Theme.of(context).backgroundColor,
      ),
      child: Center(
        child: Icon(
          Icons.error,
          color: Theme.of(context).errorColor,
          size: 100,
        ),
      ),
    );
  }

//this widgets shows up until API call is in process
  List<Widget> loadingWidget() {
    return <Widget>[
      SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 20),
        ),
      )
    ];
  }

//this widget is called when API call has failed and there is no data to show
  List<Widget> errorWidget() {
    return <Widget>[
      Icon(
        Icons.error_outline,
        color: Theme.of(context).errorColor,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Something went wrong ! Try refreshing the page.'),
      )
    ];
  }
}
