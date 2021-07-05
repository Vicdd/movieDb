import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/controllers/movie_list.dart';
import 'package:moviedb/theme/custom_theme.dart';
import 'package:moviedb/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<void> _someFuture() {
    return this._memoizer.runOnce(() async {
      return context.read<MovieListController>().getMovieList();
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
            context.read<MovieListController>().storeMovies();
            return ListView.separated(
              itemBuilder: (_, index) => MovieCard(movie: s.data[index]),
              separatorBuilder: (_, index) => Divider(height: 8.0),
              itemCount: s.data.length,
              padding: const EdgeInsets.fromLTRB(50.0, 12.0, 50.0, 12.0),
              shrinkWrap: true,
            );
          }
        },
      ),
    );
  }
}
