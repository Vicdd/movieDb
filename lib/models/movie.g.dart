// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['id'] as int?,
    movieId: json['id'] as int?,
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    title: json['title'] as String?,
    posterUrl: json['poster_url'] as String?,
    genres:
        (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    releaseDate: json['release_date'] as String?,
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'vote_average': instance.voteAverage,
      'title': instance.title,
      'poster_url': instance.posterUrl,
      'genres': instance.genres,
      'release_date': instance.releaseDate,
    };
