import 'package:encyclopedia_for_life/BackendService/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:encyclopedia_for_life/BackendService/backend_service.dart';

class DetailPage extends StatefulWidget {
  final String pageId;

  DetailPage(this.pageId);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<ItemDetailResult> _itemDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _itemDetail = BackendService.getInstance().getDetail(widget.pageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
        child: FutureBuilder<ItemDetailResult>(
          future: _itemDetail, // a previously-obtained Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<ItemDetailResult> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Image.network(snapshot.data.imageURL),
                )
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
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
}
