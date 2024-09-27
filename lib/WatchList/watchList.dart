import 'package:flutter/material.dart';
import 'package:movies_app/SharedPrefrences.dart';

import '../data/api_manager.dart';
import '../data/model/TopRated.dart';
import '../data/model/endPoint.dart';
import 'fireStoreServer.dart';
// Import FirestoreService

class WatchlistMovieItem extends StatelessWidget {
  final TopRatedOrPopular
  model; // This should be a model representing the movie
  final FirestoreService firestoreService =
  FirestoreService(); // Create an instance of FirestoreService

  WatchlistMovieItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 90,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${EndPoints.imageBaseURL}${model.posterPath}'),
                      // Assuming posterPath is part of the model
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      if (await SharedPrefs.isMovieSaved(model.toMovie())) {
                        SharedPrefs.removeMovieFromSharedPrefs(model.toMovie());
                      } else {
                        SharedPrefs.saveMovieToSharedPrefs(model.toMovie());
                      }
                      // firestoreService.removeMovieById(model.id.toString());
                      // await firestoreService.removeMovieByTitle(model.title ?? '');
                      // You can call setState in the parent widget to refresh the list
                    },
                    child: FutureBuilder(
                      future: SharedPrefs.isMovieSaved(model.toMovie()),
                      builder: (context, snapshot) {
                        return Image.asset(
                          (model.isFavorite ??
                              false) // Handle null values in isFavorite
                              ? 'assets/images/Icon awesome-bookmark.png'
                              : 'assets/images/bookmark.png',
                        );
                      },),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.title ?? '', // Title from the model
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Year: ${ApiManager.getMovieReleaseYear(
                            model.releaseDate ?? '')}',
                        // Assuming releaseDate is part of the model
                        style: const TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const ImageIcon(
                            AssetImage("Images/3.png"),
                            color: Colors.yellow,
                          ),
                          Text(
                            "${model.voteAverage}",
                            // Assuming voteAverage is part of the model
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: const Divider(
            height: 2,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}
