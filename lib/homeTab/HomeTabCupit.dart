import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/api_manager.dart';
import '../data/model/hometabResponse.dart';
import 'HomeContentStates.dart';

class Hometabcupit extends Cubit <Homecontentstates> {
  Hometabcupit():super(HomeInitState());
  List<Movie> popularMovies = [];


  void showMovies() async {
    try {
      emit(HomeInitState());

      // Call the API only once and store the result
      var response = await ApiManager.getPopular();
      print(response);


      // Check if the response is valid and has results
      popularMovies = response.results ?? [];

      // Emit success state with the response data
      emit(HomeSuccessState(response: response));


    } catch (e) {
      // Emit error state with the exception message
      emit(HomeErrorState(errorMessage: e.toString()));

    }
  }

}
