import 'package:flutter/material.dart';
import 'package:movies_app/SharedPrefrences.dart';
import 'package:movies_app/data/model/hometabResponse.dart';

import '../homeTab/movies details.dart';
import 'fireStoreServer.dart';

class WatchListTab extends StatefulWidget {
  static const String routeName = 'watchlisttab';

  @override
  State<WatchListTab> createState() => _WatchListTabState();
}

class _WatchListTabState extends State<WatchListTab> {
  final FirestoreService firestoreService =
      FirestoreService(); // Initialize Firestore service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'WatchList',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black87,
      body: FutureBuilder<List<Movie>>(
        future: SharedPrefs.loadMovieFromSharedPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No favorite movies found',
                    style: TextStyle(color: Colors.white)));
          } else if (snapshot.hasData) {
            // Data is available
            final favMovies = snapshot.data!;
            return ListView.builder(
              itemCount: favMovies.length,
              itemBuilder: (context, index) {
                final movie = favMovies[index];
                return _buildWatchlistItem(movie);
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildWatchlistItem(Movie movie) {
    // Extract movie poster path and handle null case
    final posterPath = movie.posterPath;

    // Set the imageUrl based on whether posterPath is null or not
    final imageUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500/$posterPath'
        : 'assets/images/placeholder.png'; // Fallback image

    return Container(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: () {
          // Ensure the movie['id'] exists and pass it to the details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsPage(
                movieId:
                    movie.id?.toInt() ?? 0, // Pass 'id' to the details page
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              width: 100,
              height: 130,
              child: Image.network(
                imageUrl, // Use the imageUrl here
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(child: Text('Image not available')),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    movie.title ?? 'Unknown', // Access 'title' from the map
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10), // Spacing
                Text(
                  movie.releaseDate ?? 'Release date unknown',
                  // Access 'releaseDate' from the map
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  if (await SharedPrefs.isMovieSaved(movie)) {
                    SharedPrefs.removeMovieFromSharedPrefs(movie);
                  } else {
                    SharedPrefs.saveMovieToSharedPrefs(movie);
                  }
                  // await firestoreService.removeMovieByTitle(movie['title']); // Access 'title' from the map
                  setState(() {}); // Update the state to reflect the change
                },
                icon: FutureBuilder(
                  future: SharedPrefs.isMovieSaved(movie),
                  builder: (context, snapshot) {
                    return Icon(
                      snapshot.data ?? false
                          ? Icons.bookmark_added_outlined
                          : Icons.bookmark_add_outlined,
                      color:
                          snapshot.data ?? false ? Colors.blue : Colors.white,
                      size: 30,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
