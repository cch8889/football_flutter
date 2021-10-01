import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:developer';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup Name Gen', home: DemoApp());
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Future<List> getApiData() async {
    // get request for chelsea team data
    http.Response response =
        await http.get(Uri.parse('https://api.football-data.org/v2/teams/61'),
            // Send authorization headers to the backend.
            headers: {
          'X-Auth-Token': 'df696478a0754c2587c5b849289e4dcb',
        });

    Map<String, dynamic> jsonResponse;

    // check ok response & send default on failure
    if(response.statusCode == 200){
      jsonResponse = convert.jsonDecode(response.body);
    } else{
      jsonResponse = {"name": "Name not found",
                      "address": "Address not found",
                      "crestUrl": "https://img01.bt.co.uk/s/assets/130921/images/logo/logo-2018.svg"};
    }

    // get request for matches played in last 30 days
    http.Response response2 = await http.get(
        Uri.parse('https://api.football-data.org/v2/teams/61/matches'
            ''),
        // Send authorization headers to the backend.
        headers: {
          'X-Auth-Token': 'df696478a0754c2587c5b849289e4dcb',
        });



    Map<String, dynamic> jsonResponse2;
    // create list for output
    List<Map<String, dynamic>> l = [];
    if(response2.statusCode == 200){
      jsonResponse2 = convert.jsonDecode(response2.body);
      // find todays date
      final todaysDate = DateTime.now();
      // create date format for output
      final DateFormat formatter = DateFormat('dd/MMM/yyyy');

      // for loop to iterate through API results
      for (int i = jsonResponse2['matches'].length - 1; i >= 0; i--) {
        // find game date
        var gameDate = DateTime.parse(jsonResponse2['matches'][i]['utcDate']);
        // find difference of 2 dates
        final difference = gameDate.difference(todaysDate).inDays;
        // check to see if difference is within lb and ub range
        if ((difference >= -30) && (difference <= 0)) {
          // store data into a map
          var identifier = {
            'away': jsonResponse2['matches'][i]['awayTeam'],
            'home': jsonResponse2['matches'][i]['homeTeam'],
            'score': jsonResponse2['matches'][i]['score'],
            'date': formatter.format(gameDate)
          };
          // push to a list
          l.add(identifier);
        }
      }
    }else{
      var identifier = {
        'away': {"name":"Not found"},
        'home': {"name":"Not found"},
        'score': {"fullTime":{"homeTeam":"0", "awayTeam":"0"}},
        'date': "Date not found"
      };
      // push to a list
      l.add(identifier);

    }

    // prepare data for output
    List output = [jsonResponse, l];

    //send data off
    return output;
  }

  String _name(dynamic user) {
    return user['name'];
  }

  String _address(dynamic user) {
    return user['address'];
  }

  String _logo(dynamic user) {
    return user['crestUrl'];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Football demo app"),
      ),
      body: Container(
        child: FutureBuilder<List>(
          // create future builder
          future: getApiData(), // call api function above
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // pass context
            if (snapshot.hasData) {
              // check api has returned data

              final Widget networkSvg = SvgPicture.network(
                // create widjet for logo
                _logo(snapshot.data[0]),
                semanticsLabel: 'Logo',
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()),
              );

              return Center(
                  child: Column(children: <Widget>[
                // place widget on top of each other
                networkSvg, // load image
                Container(
                  margin: EdgeInsets.all(20),
                  child: Table(
                    // create table
                    defaultColumnWidth: FixedColumnWidth(120.0),
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
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
                        Column(children: [Text(_name(snapshot.data[0]))]),
                      ]),
                      TableRow(children: [
                        Column(children: [Text('Address')]),
                        Column(children: [Text(_address(snapshot.data[0]))])
                      ]),
                    ],
                  ),
                ),
                Expanded(
                    child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: snapshot.data[1].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  "${snapshot.data[1][index]['home']['name']} played ${snapshot.data[1][index]['away']['name']} on ${snapshot.data[1][index]['date']} and the score was ${snapshot.data[1][index]['score']['fullTime']['homeTeam']} : ${snapshot.data[1][index]['score']['fullTime']['awayTeam']} "),
                            );
                          },
                        )))
              ]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
