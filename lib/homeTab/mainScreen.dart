import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../data/api_manager.dart';
import '../data/model/hometabResponse.dart';
import 'HomeContentStates.dart';
import 'HomeTabCupit.dart';
import 'NewRelease.dart';
import 'Recommended.dart';
import 'movies details.dart';


class HomeTab extends StatefulWidget {
  static const String routename = "HomeTab";
  final Hometabcupit viewmodel = Hometabcupit();

  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    widget.viewmodel.showMovies();
  }

  void toggleBookmark(int movieId) {
    setState(() {
      isFav = !isFav;
    });
    // Add logic to manage favoriteMovies[movieId] toggle
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Hometabcupit, Homecontentstates>(
      bloc: widget.viewmodel,
      builder: (BuildContext context, Homecontentstates state) {
        if (state is HomeErrorState) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is HomeSuccessState) {
          final movies = state.response.results ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('No movies available'));
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  movies.isNotEmpty
                      ? Container(
                    height: 320,
                    child: ImageSlideshow(
                      autoPlayInterval: 5000,
                      isLoop: true,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      children: [
                        for (int i = 0; i < movies.length; i++)
                          buildSlideshowItem(movies[i]),
                      ],
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  // Add New Releases and Recommended sections with space in between
                  buildNewReleasesWidget(),
                  const SizedBox(height: 20), // Added space between the two sections
                  buildRecommendedWidget(),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildSlideshowItem(Movie movie) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 217,
          child: Image.network(
            getPosterUrl(movie.posterPath),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 77,
          left: 175,
          child: IconButton(
            onPressed: () {
              // Launch movie details or trailer
            },
            icon: const Icon(Icons.play_circle_outlined, size: 50, color: Colors.white),
          ),
        ),
        Positioned(
          left: 20,
          top: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 129,
                    height: 180,
                    child: Image.network(
                      getPosterUrl(movie.posterPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 1,
                    left: 1,
                    child: IconButton(
                      onPressed: () {
                        toggleBookmark(movie.id ?? 1);
                      },
                      icon: Icon(
                        isFav ? Icons.bookmark_added_outlined : Icons.bookmark_add_outlined,
                        color: isFav ? Colors.yellow : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 160,
          top: 225,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? 'No Title Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        movie.originalLanguage ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        movie.releaseDate ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigate to movie details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                movieId: movie.id ?? 1, // Pass the movie ID
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info,
                          color: Colors.blueGrey,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNewReleasesWidget() {
    return Container(
      color: Colors.white12,
      height: 255,
      child: Newrealseswidget(
        snapshot: ApiManager.getNewRealeases(),
        title: 'New Releases',
      ),
    );
  }

  Widget buildRecommendedWidget() {
    return Container(
      color: const Color(0xff282A28),
      height: 330,
      child: RecommendedMovies(
        snapshot: ApiManager.recommendedMovies(),
        title: 'Recommended',
      ),
    );
  }

  // Utility method for poster URL
  String getPosterUrl(String? posterPath) {
    return posterPath != null
        ? 'https://image.tmdb.org/t/p/w500/$posterPath'
        : 'https://via.placeholder.com/150';
  }
}
