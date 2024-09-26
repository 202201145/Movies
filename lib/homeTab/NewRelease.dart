import 'package:flutter/material.dart';
import '../data/model/NewReleases.dart';
import 'movies details.dart';

class Newrealseswidget extends StatefulWidget {
  final Future<List<Response>> snapshot;
  final String title;

  Newrealseswidget({
    required this.snapshot,
    required this.title,
    super.key,
  });

  @override
  _NewrealseswidgetState createState() => _NewrealseswidgetState();
}

class _NewrealseswidgetState extends State<Newrealseswidget> {
  Set<int> bookmarkedMovies = {}; // Set to store bookmarked movie IDs

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
    return FutureBuilder<List<Response>>(
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 180,  // Increased height for larger images
              width: double.infinity,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 25),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final movie = data[index];
                  final isBookmarked = bookmarkedMovies.contains(movie.id);

                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigate to MovieDetailsPage with the selected movie
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsPage(movieId: movie.id??0),
                            ),
                          );
                        },
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left:-10,
                        child: IconButton(
                          onPressed: () {
                            toggleBookmark(movie.id ?? 0);
                          },
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark_added_outlined
                                : Icons.bookmark_add_outlined,
                            color: isBookmarked ? Colors.yellow : Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
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
