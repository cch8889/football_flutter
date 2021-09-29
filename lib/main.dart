// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _TableExample createState() => _TableExample();
}

class _TableExample extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Chelsea Fc'),
          ),
          body: Center(
              child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Details', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Value', style: TextStyle(fontSize: 20.0))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Team Name')]),
                    Column(children: [Text('Chelsea')]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Manager')]),
                    Column(children: [Text('Tuchel')]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Wins')]),
                    Column(children: [Text('5')])
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Draws')]),
                    Column(children: [Text('1')])
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Loses')]),
                    Column(children: [Text('0')])
                  ]),
                  TableRow(children: [
                    Column(children: [Text('Points')]),
                    Column(children: [Text('16')])
                  ]),
                ],
              ),
            ),
          ]))),
    );
  }
}
