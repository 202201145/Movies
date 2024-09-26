import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String apiKey = '1b257db8dc3e1cdcf56da88d4ea73060'; // Your TMDb API key
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch categories (genres) and their images from TMDb
  Future<List<Map<String, String>>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> genres = data['genres'];
      List<Map<String, String>> categories = [];

      // Fetch movies by genre to get a relevant image for each category
      for (var genre in genres) {
        final moviesResponse = await http.get(Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=${genre['id']}'));

        if (moviesResponse.statusCode == 200) {
          final moviesData = json.decode(moviesResponse.body);
          final List<dynamic> movies = moviesData['results'];

          String? backdropPath;
          if (movies.isNotEmpty && movies[0]['backdrop_path'] != null) {
            backdropPath = 'https://image.tmdb.org/t/p/w500${movies[0]['backdrop_path']}';
          } else {
            backdropPath = 'https://via.placeholder.com/500x281?text=No+Image'; // Placeholder if no image found
          }

          // Add category with its corresponding image
          categories.add({
            'id': genre['id'].toString(),
            'name': genre['name'],
            'image': backdropPath, // Image for the category
          });
        }
      }
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch movies by genre/category ID
  Future<List<Map<String, String>>> fetchMoviesByCategory(String genreId) async {
    final response = await http.get(Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> movies = data['results'];
      List<Map<String, String>> movieList = [];

      for (var movie in movies) {
        movieList.add({
          'title': movie['title'],
          'poster_path': 'https://image.tmdb.org/t/p/w500${movie['poster_path']}', // Movie poster
          'id': movie['id'].toString(), // Movie ID
        });
      }

      return movieList;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
