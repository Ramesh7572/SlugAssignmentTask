import 'dart:convert';

import 'package:app_assignment/pages/grid_view_item.dart';
import 'package:app_assignment/theme/color.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://followchess.com/config.json";
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['trns'];
      setState(() {
        users = items;
        isLoading = false;
      });
    } else {
      users = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item List"),
        actions: [
          FlatButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => GridViewItem()));
              },
              icon: Icon(
                Icons.grid_view,
                color: Colors.white,
              ),
              label: Text(''))
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (users.contains(null) || users.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(item) {
    var name = item['name'];
    var slug = item['slug'];
    var year = slug.toString().substring(slug.toString().length - 4);
    var dashCal = '-'.allMatches(slug.toString()).length;
    var profileUrl = item['img'];
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(100 / 2),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profileUrl != null
                            ? profileUrl
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfFVI771jkfWHKbUCEOWlrK3CbTbt-0x_c_A&usqp=CAU"))),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          "Name: " + name,
                          style: TextStyle(fontSize: 17),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          "Slug: " + slug,
                          style: TextStyle(fontSize: 17),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          "Year: " + year,
                          style: TextStyle(fontSize: 17),
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          "No of Dash: " + dashCal.toString(),
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
