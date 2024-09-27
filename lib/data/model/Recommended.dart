import 'package:movies_app/data/model/hometabResponse.dart';

class RecommdedData {
  final int id;
  final String? title;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? runtime; // Example field for runtime

  RecommdedData({
    required this.id,
    this.title,
    this.posterPath,
    this.releaseDate,
    this.voteAverage,
    this.runtime,
  });

  factory RecommdedData.fromJson(Map<String, dynamic> json) {
    return RecommdedData(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average']?.toDouble(),
      runtime: json['runtime'], // Assuming the runtime is provided in minutes
    );
  }

  toMovie() {
    return Movie(
        isFavorite: false,
        adult: null,
        backdropPath: null,
        genreIds: null,
        id: id,
        originalLanguage: null,
        originalTitle: null,
        overview: null,
        popularity: null,
        posterPath: posterPath,
        releaseDate: releaseDate,
        title: title,
        video: null,
        voteAverage: voteAverage,
        voteCount: null);
  }



}