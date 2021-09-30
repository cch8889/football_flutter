import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:developer';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Startup Name Gen', home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Future<List> func_name() async {
    http.Response response =
        await http.get(Uri.parse('https://api.football-data.org/v2/teams/61'),
            // Send authorization headers to the backend.
            headers: {
          'X-Auth-Token': 'df696478a0754c2587c5b849289e4dcb',
        });

    http.Response response2 = await http.get(
        Uri.parse('https://api.football-data.org/v2/teams/61/matches'
            ''),
        // Send authorization headers to the backend.
        headers: {
          'X-Auth-Token': 'df696478a0754c2587c5b849289e4dcb',
        }
    );

    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Map<String, dynamic> jsonResponse2 = convert.jsonDecode(response2.body);

    final todaysDate = DateTime.now();

    List<Map<String, dynamic>> l = [];

    for(int i = 0; i < jsonResponse2['matches'].length; i++){
      print(jsonResponse2['matches'][i]['competition']['name']);
        print(todaysDate);
        var gameDate = DateTime.parse(jsonResponse2['matches'][i]['utcDate']);
        final difference = gameDate.difference(todaysDate).inDays;
        if((difference >= -30) && (difference <= 0)) {
            print(jsonResponse2['matches'][i]);
            var identifier = { 'away':jsonResponse2['matches'][i]['awayTeam'], 'home':jsonResponse2['matches'][i]['homeTeam'],  'score':jsonResponse2['matches'][i]['score']};
            l.add(identifier);
        }
    }

    List output = [jsonResponse,l];

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
        title: Text("jsonResponse"),
      ),
      body:
        Container(
        child: FutureBuilder<List>(
          future: func_name(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("Check ${_name(snapshot.data[0])}");
              print("Check ${_address(snapshot.data[0])}");
              if(snapshot.data[1][0]['away']['name']=='Chelsea FC'){
                    print(snapshot.data[1][0]['away']['name']['coach']);
              }else if(snapshot.data[1][0]['home']['name']=='Chelsea FC'){
                    print(snapshot.data[1][0]['home']['name']['coach']);
              }


              // for(int i = 0; i < snapshot.data[1].length; i++){
              //
              //   print();
              // }

              final Widget networkSvg = SvgPicture.network(
                  _logo(snapshot.data[0]),
                semanticsLabel: 'Logo',
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()),
              );


              return Center(
                  child: Column(children: <Widget>[networkSvg,
                Container(
                  margin: EdgeInsets.all(20),
                  child: Table(
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
                      TableRow(children: [
                        Column(children: [Text('Address')]),
                        Column(children: [Text(_address(snapshot.data[0]))])
                      ]),
                    ],
                  ),
                )
              ,new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                    return new Card(
                    child: const ListTile(
                    subtitle: const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    )]));
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
