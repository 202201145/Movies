import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/homeTab/movies%20details.dart';
import 'package:movies_app/searchScreen/searchCupit.dart';
import 'package:movies_app/searchScreen/searchStates.dart';

class SearchScreen extends StatelessWidget {
  static const String routename = 'searchtab';

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, Searchstates>(
        builder: (context, state) {
          final viewmodel = BlocProvider.of<SearchCubit>(context);

          return Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar with improved styling
                  SizedBox(height: 50),
                  TextField(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    controller: searchController,
                    onChanged: (value) {
                      viewmodel.searchMovie(query: value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      labelText: 'Search For Movie',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                  ),

                  // Display results or loading/error indicators
                  SizedBox(height: 20),
                  if (searchController.text.isEmpty && state is SearchSuccessState && viewmodel.searchResults.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_movies_sharp, size: 250, color: Colors.white38),
                          Text('No Movies Found', style: TextStyle(color: Colors.white60)),
                        ],
                      ),
                    )
                  else if (state is SearchLoadingState)
                    Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  else if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewmodel.searchResults.length,
                          itemBuilder: (context, index) {
                            final movie = viewmodel.searchResults[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetailsPage(movieId: movie.id??0)));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(bottom: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '${'https://image.tmdb.org/t/p/w500/'}${movie.posterPath}',
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Center(child: Icon(Icons.error, color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    // Movie details with improved formatting
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            movie.releaseDate ?? '',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else if (state is SearchErrorState)
                        Center(
                          child: Text(
                            'Error occurred while searching for movies. Movie not found.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
