import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/model/hometabResponse.dart';

class SharedPrefs {
  static Future<void> saveMovieToSharedPrefs(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String movieJson = jsonEncode(movie.toJson());
    List<String>? movies = prefs.getStringList('saved_movie');
    if (movies != null) {
      movies.add(movieJson);
      prefs.setStringList('saved_movie', movies);
    }
  }

  // Load Movie object from SharedPreferences
  static Future<List<Movie>> loadMovieFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? movieJson = prefs.getStringList('saved_movie');
    print(movieJson);
    List<Movie> movies = [];
    if (movieJson != null) {
      for (var movie in movieJson) {
        Map<String, dynamic> movieMap = jsonDecode(movie);
        movies.add(Movie.fromJson(movieMap));
      }
    }
    return movies;
  }

  static Future<void> removeMovieFromSharedPrefs(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? movieJson = prefs.getStringList('saved_movie');

    if (movieJson != null) {
      // Find and remove the movie by comparing the unique identifier (id)
      movieJson.removeWhere((savedMovie) {
        Map<String, dynamic> movieMap = jsonDecode(savedMovie);
        Movie savedMovieObj = Movie.fromJson(movieMap);
        return savedMovieObj.id == movie.id;
      });

      // Update the SharedPreferences with the new list
      prefs.setStringList('saved_movie', movieJson);
    }
  }

  static Future<bool> isMovieSaved(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? movieJson = prefs.getStringList('saved_movie');

    if (movieJson != null) {
      for (var savedMovie in movieJson) {
        Map<String, dynamic> movieMap = jsonDecode(savedMovie);
        Movie savedMovieObj = Movie.fromJson(movieMap);

        // Compare the unique identifier (e.g., movie ID)
        if (savedMovieObj.id == movie.id) {
          return true;
        }
      }
    }

    return false;
  }
}
