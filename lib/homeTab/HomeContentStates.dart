
import '../data/model/hometabResponse.dart';

abstract class Homecontentstates {}

class HomeInitState extends Homecontentstates {}

class HomeLoadingState extends Homecontentstates {}



class HomeSuccessState extends Homecontentstates {
  HometabResponse response;
  HomeSuccessState({required this.response});
}

class HomeErrorState extends Homecontentstates {
  final String errorMessage;
  HomeErrorState({required this.errorMessage});
}