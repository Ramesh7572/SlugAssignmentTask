import 'dart:convert';

import 'package:app_assignment/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GridViewItem extends StatefulWidget {
  const GridViewItem({Key? key}) : super(key: key);

  @override
  _GridViewItemState createState() => _GridViewItemState();
}

class _GridViewItemState extends State<GridViewItem> {
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
        title: Text("Grid List"),
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
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      profileUrl != null
                          ? profileUrl
                          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfFVI771jkfWHKbUCEOWlrK3CbTbt-0x_c_A&usqp=CAU",
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          "Name: " + name,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                )),
          ],
        ));
  }
}
