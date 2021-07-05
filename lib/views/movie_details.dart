import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/controllers/movie_list.dart';
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/theme/custom_theme.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailsPage({Key? key, @required required this.movie})
      : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> _someFuture() {
    return this._memoizer.runOnce(() async {
      final mCon = context.read<MovieListController>();
      return mCon.getMovieDetails(widget.movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Color(CTheme.tertiaryColor),
      ),
      body: FutureBuilder(
        future: _someFuture(),
        builder: (BuildContext context, AsyncSnapshot s) {
          if (s.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (s.hasError) {
            return Center(
              child: Text(
                'Internet connection error',
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            context.read<MovieListController>().storeMovieDetails(s.data);
            return MovieDetailsCard(movie: s.data);
          }
        },
      ),
    );
  }
}

class MovieDetailsCard extends StatelessWidget {
  final Movie movie;
  const MovieDetailsCard({Key? key, @required required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4.0),
              Container(
                height: 252,
                child: Image.memory(
                  movie.image ?? Uint8List(0),
                  errorBuilder: (context, obj, stack) {
                    return Center(
                      child: Text('Error loading image'),
                    );
                  },
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                movie.title ?? '',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                'Status: ' + movie.details!.status!,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Released on: ' + movie.releaseDate!,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Score: ' +
                    movie.voteAverage.toString() +
                    ' (' +
                    movie.details!.voteCount.toString() +
                    ' votes)',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Duration: ' + movie.details!.runtime.toString() + ' min',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Original language: ' + movie.details!.originalLang.toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 30.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.genres?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Text(
                      (index == 0 ? 'Genres: ' : '') +
                          (movie.genres?[index] ?? '') +
                          ' ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
