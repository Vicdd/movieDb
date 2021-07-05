import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  int? id;
  int? movieId;
  double? voteAverage;
  String? title;
  String? posterUrl;
  Uint8List? image;
  List<String>? genres;
  String? releaseDate;
  MovieDetails? details;

  Movie({
    this.id,
    this.movieId,
    this.voteAverage,
    this.title,
    this.posterUrl,
    this.genres,
    this.releaseDate,
    this.image,
    this.details,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movie_id': movieId,
      'vote_average': voteAverage,
      'title': title,
      'poster_url': posterUrl,
      'image': image,
      'release_date': releaseDate,
      'genres': genres?.join(',')
    };
  }

  factory Movie.fromJsonDb(Map<String, dynamic> json) {
    String? genres = json['genres'];
    return Movie(
      id: json['id'] as int?,
      movieId: json['movie_id'] as int?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      title: json['title'] as String?,
      image: json['image'] as Uint8List?,
      posterUrl: json['poster_url'] as String?,
      genres: genres?.split(','),
      releaseDate: json['release_date'] as String?,
    );
  }
}

class MovieDetails {
  int? id;
  int? runtime;
  int? voteCount;
  String? status;
  String? originalLang;

  MovieDetails({
    this.id,
    this.runtime,
    this.voteCount,
    this.status,
    this.originalLang,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'runtime': runtime,
      'vote_count': voteCount,
      'status': status,
      'original_language': originalLang,
    };
  }

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'] as int?,
      runtime: json['runtime'] as int?,
      voteCount: json['vote_count'] as int?,
      status: json['status'] as String?,
      originalLang: json['original_language'] as String?,
    );
  }
}
