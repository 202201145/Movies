import 'package:flutter/material.dart';
import 'package:movies_app/homeTab/movies%20details.dart';
import '../data/model/Recommended.dart';

class RecommendedMovies extends StatefulWidget {
  final Future<List<RecommdedData>> snapshot;
  final String title;

  const RecommendedMovies({
    required this.snapshot,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  _RecommendedMoviesState createState() => _RecommendedMoviesState();
}

class _RecommendedMoviesState extends State<RecommendedMovies> {
  Set<int> bookmarkedMovies = {}; // Set to store bookmarked movie IDs

  // Toggles bookmark status of a movie
  void toggleBookmark(int movieId) {
    setState(() {
      if (bookmarkedMovies.contains(movieId)) {
        bookmarkedMovies.remove(movieId); // Remove if already bookmarked
      } else {
        bookmarkedMovies.add(movieId); // Add if not bookmarked
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecommdedData>>(
      future: widget.snapshot,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error.toString()}'));
        } else if (!snap.hasData || snap.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snap.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 260, // Fixed height to include image and details
              width: double.infinity,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 25),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final movie = data[index];
                  final isBookmarked = bookmarkedMovies.contains(movie.id);

                  return SizedBox(
                    width: 120, // Set a fixed width to prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigate to MovieDetailsPage with the selected movie
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetailsPage(movieId: movie.id)
                                  ),
                                );
                              },
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                height: 150, // Set the height of the image
                                width: 120, // Fixed width for image
                              ),
                            ),
                            Positioned(
                              top: -12,
                              left: -10,
                              child: IconButton(
                                onPressed: () {
                                  toggleBookmark(movie.id );
                                },
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark_added_outlined
                                      : Icons.bookmark_add_outlined,
                                  color:
                                  isBookmarked ? Colors.yellow : Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5), // Spacing between image and text
                        // Movie title
                        Text(
                          movie.title ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // Ensures text wraps properly
                        ),
                        const SizedBox(height: 5),
                        // Release Year, Rating, and Runtime
                        Row(
                          children: [
                            Text(
                              movie.releaseDate?.substring(0, 4) ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            Text(
                              movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${movie.runtime ?? 'N/A'} min',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
