import 'package:film_fan/MovieDetails.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

class NowMovies extends StatefulWidget {
  @override
  _NowMoviesState createState() => _NowMoviesState();
}

class _NowMoviesState extends State<NowMovies> {
  Future _getMovies() async {
    var baseUrl = 'https://api.themoviedb.org/3';
    var apiKey = 'api_key=220415258c01260a8f80dab6ce703364';
    Response response = await get('$baseUrl/movie/now_playing?$apiKey');
    var jsonData = jsonDecode(response.body);
    var data = jsonData['results'];
    return data;
  }

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: new AppBar(
          backgroundColor: Colors.blue[900],
          title: new Text('The now playing movies'),
        ),
        body: Container(
          child: FutureBuilder(
              future: _getMovies(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(children: <Widget>[
                              SizedBox(height: 10),
                              Divider(),
                              FlatButton.icon(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetails(
                                        movieId: snapshot.data[index]['id'],
                                      ),
                                    ),
                                  ),
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                                label: Expanded(
                                  child: Text(
                                    snapshot.data[index]['title'],
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              new Image.network(
                                  'https://image.tmdb.org/t/p/w400' +
                                      snapshot.data[index]['poster_path']),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Vote Average: ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    snapshot.data[index]['vote_average']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Release Date: ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    snapshot.data[index]['release_date']
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        );
                      });
                }
              }),
        ));
  }
}
