import 'package:flutter/material.dart';
import '../homeTab/movies details.dart';
import 'apl client.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final String categoryId;

  CategoryDetailScreen({required this.category, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('$category Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, String>>>(
        future: ApiClient().fetchMoviesByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
          }

          final movies = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return MovieCard(
                title: movies[index]['title']!,
                posterPath: movies[index]['poster_path']!,
                movieId: int.parse(movies[index]['id']!), // Pass the movie ID
              );
            },
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String posterPath;
  final int movieId;

  MovieCard({required this.title, required this.posterPath, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movieId: movieId),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              posterPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, color: Colors.red);
              },
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ); // Close GestureDetector
  }
}
