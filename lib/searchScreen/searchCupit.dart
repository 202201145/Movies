import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/searchScreen/searchStates.dart';
import '../data/api_manager.dart';
import '../data/model/searchReponse.dart';

class SearchCubit extends Cubit<Searchstates> {
  SearchCubit() : super(SearchInitState());

  List<SearchResults> searchResults = [];

  void searchMovie({required String query}) async {
    try {
      emit(SearchLoadingState());

      var response = await ApiManager.searchMovies(query);
      searchResults = response.results ?? [];

      emit(SearchSuccessState(response: response));
      print('Success: ${searchResults.isNotEmpty ? searchResults[0].title : 'No movies found'}');
    } catch (e) {
      emit(SearchErrorState(errorMessage: e.toString()));
      throw e; // Consider logging or handling the error appropriately
    }
  }

  // New method to clear the search results and reset the state
  void clearSearch() {
    searchResults.clear(); // Clear the search results
    emit(SearchInitState()); // Reset to the initial state
  }
}
