import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shared_preferences/shared_preferences.dart'; // استيراد SharedPreferences

import '../SharedPrefrences.dart';
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
  List<bool> isFavList = []; // List to hold bookmark status for each movie

  @override
  void initState() {
    super.initState();
    widget.viewmodel.showMovies();
    _loadFavorites(); // Load favorites on initialization
  }

  // Load favorite movies from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // استرجاع حالة المفضلة من SharedPreferences
      isFavList = List<bool>.from(
          prefs.getStringList('favorites')?.map((e) => e == 'true') ?? []);
    });
  }

  // Save favorite movies to SharedPreferences
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'favorites', isFavList.map((e) => e.toString()).toList());
  }

  // Toggle bookmark status for a specific movie based on its index
  void toggleBookmark(int index) {
    setState(() {
      isFavList[index] =
          !isFavList[index]; // Toggle bookmark for this specific movie
      _saveFavorites(); // Save the updated favorites list
    });
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

          // Initialize isFavList with false for all movies
          if (isFavList.isEmpty && movies.isNotEmpty) {
            isFavList = List.filled(movies.length, false);
            _saveFavorites(); // Save the initial state
          }

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
                      ? SizedBox(
                          height: 320,
                          child: ImageSlideshow(
                            autoPlayInterval: 5000,
                            isLoop: true,
                            initialPage: 0,
                            indicatorColor: Colors.blue,
                            indicatorBackgroundColor: Colors.grey,
                            children: List.generate(
                              movies.length,
                              (index) =>
                                  buildSlideshowItem(movies[index], index),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),

                  buildNewReleasesWidget(),
                  const SizedBox(height: 20),
                  // Added space between the two sections
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

  Widget buildSlideshowItem(Movie movie, int index) {
    return Stack(
      children: [
        SizedBox(
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
            icon: const Icon(Icons.play_circle_outlined,
                size: 50, color: Colors.white),
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
                      onPressed: () async {
                        if (await SharedPrefs.isMovieSaved(movie)) {
                          SharedPrefs.removeMovieFromSharedPrefs(movie);
                        } else {
                          SharedPrefs.saveMovieToSharedPrefs(movie);
                        }
                        setState(() {});

                        // FirestoreService.addMovieToFirestore(
                        //   id: movie.id.toString(),
                        //   title: movie.title ?? '',
                        //   imagePath: movie.posterPath ?? '',
                        //   description: movie.overview ?? '',
                        // );
                        // toggleBookmark(
                        //     index); // Toggle bookmark for this specific movie
                      },
                      icon: FutureBuilder(
                        future: SharedPrefs.isMovieSaved(movie),
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
                                movieId:
                                    movie.id?.toInt() ?? 0, // Pass the movie ID
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
