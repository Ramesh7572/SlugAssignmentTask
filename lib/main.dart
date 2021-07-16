import 'package:app_assignment/pages/grid_view_item.dart';
import 'package:app_assignment/pages/index.dart';
import 'package:app_assignment/theme/color.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: primary),
      home: IndexPage(),
    ));
