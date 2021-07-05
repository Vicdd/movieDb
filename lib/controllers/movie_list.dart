import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moviedb/database_helper.dart';
import 'package:moviedb/models/movie.dart';
import 'package:http/http.dart' as http;

class MovieListController with ChangeNotifier {
  List<Movie> movies = [];

  Future loadImages() async {
    for (int i = 0; i < movies.length; i++)
      movies[i].image = await http
          .get(Uri.parse(movies[i].posterUrl ?? ''))
          .then((value) => value.bodyBytes);
  }

  Future loadMoviesRoute() async {
    Uri url =
        Uri.parse('https://desafio-mobile.nyc3.digitaloceanspaces.com/movies');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      throw (e);
    }

    var json = jsonDecode(response.body);
    var i = 1;
    json.forEach((item) {
      var a = Movie.fromJson(item);
      a.movieId = a.id;
      a.id = i++;
      movies.add(a);
    });

    await loadImages();
    notifyListeners();
  }

  Future loadMoviesDatabase() async {
    final dbHelper = DatabaseHelper.instance;

    var mapList = await dbHelper.queryAllRows('movies');
    for (Map<String, dynamic> map in mapList) {
      movies.add(Movie.fromJsonDb(map));
    }

    notifyListeners();
  }

  Future<List<Movie>?> getMovieList() async {
    if (movies.isEmpty) {
      final dbHelper = DatabaseHelper.instance;
      final num = await dbHelper.queryRowCount('movies');
      num > 0 ? await loadMoviesDatabase() : await loadMoviesRoute();
    }
    return movies;
  }

  Future storeMovies() async {
    final dbHelper = DatabaseHelper.instance;
    if (await dbHelper.queryRowCount('movies') == 0) {
      for (Movie movie in movies) {
        dbHelper.insert('movies', movie.toMap());
      }
    }
  }

  Future<Movie>? getMovieDetails(Movie movie) async {
    final dbHelper = DatabaseHelper.instance;
    var instance = await dbHelper.query('movie_details', movie.movieId!);
    if (instance.isEmpty) {
      var url = Uri.parse(
          'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies/${movie.movieId}');
      http.Response response;
      try {
        response = await http.get(url);
      } catch (e) {
        throw (e);
      }
      movie.details = MovieDetails.fromJson(jsonDecode(response.body));
      return movie;
    } else {
      movie.details = MovieDetails.fromJson(instance);
      return movie;
    }
  }

  Future storeMovieDetails(Movie movie) async {
    final dbHelper = DatabaseHelper.instance;
    var instance = await dbHelper.query('movie_details', movie.movieId!);
    if (instance.isEmpty) {
      var row = movie.toMap();
      row['details_id'] = movie.movieId;
      dbHelper.update('movies', row);
      dbHelper.insert('movie_details', movie.details!.toJson());
    }
  }
}
