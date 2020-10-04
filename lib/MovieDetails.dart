import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;

  const MovieDetails({Key key, @required this.movieId}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState(this.movieId);
}

class _MovieDetailsState extends State<MovieDetails> {
  int _movieId;
  var movieDetail;
  double rating;
  var message;
  var loading = false;
  var baseUrl = 'https://api.themoviedb.org/3';
  var apiKey = 'api_key=220415258c01260a8f80dab6ce703364';

  _MovieDetailsState(this._movieId);
  Future viewDetails() async {
    Response response = await get('$baseUrl/movie/$_movieId?$apiKey');
    var data = await jsonDecode(response.body);
    setState(() {
      movieDetail = data;
    });
    return data;
  }

  void handleSubmit() async {
    setState(() {
      loading = true;
    });
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Response response = await post('$baseUrl/movie/$_movieId/rating?$apiKey',
        headers: requestHeaders, body: toEncodable({rating}));
    Map<String, dynamic> body = jsonDecode(response.body);
    setState(() {
      message = body['status_message'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    viewDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Movie Details'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                movieDetail == null
                    ? Container(
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movieDetail['title'],
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Release Date: ' + movieDetail['release_date'],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Rating: ' + movieDetail['vote_count'].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 15),
                          new Image.network(
                            'https://image.tmdb.org/t/p/w400' +
                                movieDetail['poster_path'],
                          ),
                          SizedBox(height: 15),
                          Text(
                            movieDetail['overview'],
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            message != null ? message : '',
                            style:
                                TextStyle(color: Colors.red[900], fontSize: 17),
                          ),
                          SizedBox(height: 20),
                          SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (double rate) {
                              setState(() {
                                rating = rate;
                              });
                            },
                            starCount: 5,
                            rating: rating != null ? rating : 0,
                            size: 40.0,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            color: Colors.yellow[800],
                            borderColor: Colors.yellow[800],
                            spacing: 0.0,
                          ),
                          FlatButton(
                            onPressed: rating == 0.0 ? null : handleSubmit,
                            disabledColor: Colors.grey[500],
                            disabledTextColor: Colors.grey,
                            child: loading
                                ? Text('Loading...')
                                : Text(
                                    'Submit Rate',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        backgroundColor: Colors.blue[900]),
                                  ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toEncodable(Set<double> set) {}
}
