import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/views/movie_details.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({Key? key, @required required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: movie),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
