import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/NewReleases.dart';
import 'model/Recommended.dart';
import 'model/searchReponse.dart';
import 'model/hometabResponse.dart';

class ApiManager {
  static final String _baseUrl = 'api.themoviedb.org';
  static final String _apiKey = '1b257db8dc3e1cdcf56da88d4ea73060';

  // Fetch movie details by movie ID
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('https://$_baseUrl/3/movie/$movieId?api_key=$_apiKey'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  // Fetch similar movies by movie ID
  Future<List<dynamic>> getSimilarMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('https://$_baseUrl/3/movie/$movieId/similar?api_key=$_apiKey'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  // Search for movies by query
  static Future<SearchResponse> searchMovies(String query) async {
    var headers = {
      'accept': 'application/json',
      'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlN2MzOGFjMmFkNDZlMTNjZWRkZmJkODY4MWVmMDljNiIsIm5iZiI6MTcyNjU4MzMwMi4zMzU0NDEsInN1YiI6IjY2ZTk5MDEyMWJlY2E4Y2UwN2QyZTliYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yfWSVG40lcpxu1MYOZOUEwY_15NdwS7JvIfDrFsEMhs'
    };

    try {
      Uri url = Uri.https(_baseUrl, '3/search/movie', {'query': query});

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return SearchResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load movie search results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Fetch new releases
  static Future<List<Response>> getNewRealeases() async {
    try {
      Uri url = Uri.https(_baseUrl, '3/movie/upcoming', {
        'language': 'en-US',
        'page': '1',
        'api_key': _apiKey,
      });

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)['results'] as List;
        return decodedData.map((newr) => Response.fromJson(newr)).toList();
      } else {
        throw Exception(
            'Failed to load new releases. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching new releases: $e');
    }
  }

  // Fetch recommended movies
  static Future<List<RecommdedData>> recommendedMovies() async {
    try {
      Uri url = Uri.https(_baseUrl, '3/movie/top_rated', {
        'language': 'en-US',
        'page': '1',
        'api_key': _apiKey,
      });

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)['results'] as List;
        return decodedData
            .map((recommend) => RecommdedData.fromJson(recommend))
            .toList();
      } else {
        throw Exception(
            'Failed to load recommended movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recommended movies: $e');
    }
  }

  // Fetch popular movies
  static Future<HometabResponse> getPopular() async {
    try {
      Uri url = Uri.https(_baseUrl, '3/movie/popular', {
        'language': 'en-US',
        'page': '1',
        'api_key': _apiKey,
      });

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return HometabResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load popular movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  // Fetch genres list
  Future<List<dynamic>> getGenresList() async {
    final response = await http.get(
      Uri.parse('https://$_baseUrl/3/genre/movie/list?api_key=$_apiKey'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['genres'];
    } else {
      throw Exception('Failed to load genres list');
    }
  }

  // Fetch movies by genre
  Future<List<dynamic>> getMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse(
        'https://$_baseUrl/3/discover/movie?api_key=$_apiKey&with_genres=$genreId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }
}
