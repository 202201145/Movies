import 'package:flutter/material.dart';
import 'package:movies_app/SharedPrefrences.dart';
import 'package:movies_app/WatchList/fireStoreServer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد SharedPreferences
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

  @override
  void initState() {
    super.initState();
    // _loadBookmarkedMovies(); // Load the bookmarked movies on initialization
  }

  // Load bookmarked movies from SharedPreferences
  Future<void> _loadBookmarkedMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedMovies = (prefs.getStringList('bookmarkedMovies') ?? [])
          .map((id) => int.parse(id))
          .toSet(); // Load bookmarked movie IDs
    });
  }

  // Save bookmarked movies to SharedPreferences
  Future<void> _saveBookmarkedMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'bookmarkedMovies',
      bookmarkedMovies.map((id) => id.toString()).toList(),
    ); // Save bookmarked movie IDs
  }

  void toggleBookmark(int movieId) {
    setState(() {
      // if (bookmarkedMovies.contains(movieId)) {
      //   bookmarkedMovies.remove(movieId); // Remove if already bookmarked
      // } else {
      //   bookmarkedMovies.add(movieId); // Add if not bookmarked
      // }
      // _saveBookmarkedMovies(); // Save the updated bookmarked list
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
            const SizedBox(height: 10),
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
              height: 180, // Increased height for larger images
              width: double.infinity,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 25),
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
                                  MovieDetailsPage(movieId: movie.id ?? 0),
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
                        left: -10,
                        child: IconButton(
                          onPressed: () async {
                            if (await SharedPrefs.isMovieSaved(movie.toMovie())) {
                            SharedPrefs.removeMovieFromSharedPrefs(movie.toMovie());
                            } else {
                            SharedPrefs.saveMovieToSharedPrefs(movie.toMovie());
                            }
                            setState(() {});
                            // FirestoreService.addMovieToFirestore(
                            //   id: movie.id.toString(),
                            //   title: movie.title ?? '',
                            //   imagePath: movie.posterPath ?? '',
                            //   description: movie.overview ?? '',
                            // );
                            // toggleBookmark(
                            //     movie.id ?? 0); // Toggle bookmark status
                          },
                          icon: FutureBuilder(
                            future: SharedPrefs.isMovieSaved(movie.toMovie()),
                            builder: (context, snapshot) {
                              return Icon(
                                snapshot.data ?? false
                                    ? Icons.bookmark_added_outlined
                                    : Icons.bookmark_add_outlined,
                                color:
                                snapshot.data ?? false ? Colors.yellow : Colors.white,
                                size: 30,
                              );
                            },
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
