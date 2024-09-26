import 'package:flutter/material.dart';
import 'package:movies_app/homeTab/Recommended.dart';
import '../data/api_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;
  static const String routename = 'Details';

  const MovieDetailsPage({required this.movieId, Key? key}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<Map<String, dynamic>> movieDetailsFuture;

  @override
  void initState() {
    super.initState();
    movieDetailsFuture = ApiManager().getMovieDetails(widget.movieId);
  }

  void _playMovie(String? videoUrl) async {
    if (videoUrl != null && await canLaunch(videoUrl)) {
      await launch(videoUrl);
    } else {
      print("Could not launch $videoUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final movie = snapshot.data!;
          final posterUrl =
              'https://image.tmdb.org/t/p/w500/${movie['poster_path']}';
          final backdropUrl =
              'https://image.tmdb.org/t/p/w500/${movie['backdrop_path']}';

          // Assuming you have a YouTube link for the movie in the API response
          final String? youtubeUrl = movie['youtube_url']; // Make sure this is included in your API response

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop image with play button
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      child: Image.network(
                        backdropUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Play button
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 50, // Adjust the position as needed
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _playMovie(youtubeUrl),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie title and year
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie['title'] ?? 'No Title Available',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            movie['release_date']?.split('-')[0] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Movie poster and rating in a row
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              posterUrl,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Genres (Action, Adventure, etc.)
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: List<Widget>.generate(
                                    (movie['genres'] as List).length,
                                        (int index) {
                                      return Chip(
                                        label: Text(
                                          movie['genres'][index]['name'],
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.grey[800],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Rating
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie['vote_average'] != null
                                          ? movie['vote_average'].toString()
                                          : 'N/A',
                                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Overview
                                Text(
                                  movie['overview'] ?? 'No overview available',
                                  style: const TextStyle(color: Colors.white70),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Recommended movies section
                Container(
                  child: RecommendedMovies(
                    snapshot: ApiManager.recommendedMovies(),
                    title: 'Recommended Movies',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
