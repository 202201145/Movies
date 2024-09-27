import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addMovieToFirestore(
      {
      required String title,
      required String id,
      required String imagePath,
      required String description}) async {
    // Reference to Firestore collection 'FavMovie'
    CollectionReference movies =
        FirebaseFirestore.instance.collection('movies');

    // Data to be added
    Map<String, dynamic> movieData = {
      'id ': id,
      'title': title,
      'imagePath': imagePath,
      'description': description,
      'timestamp': FieldValue
          .serverTimestamp(), // Optional: to track when the movie was added
    };

    try {
      print('Movie added to Firestore');
      await movies.add(movieData);
    } catch (e) {
      print('Failed to add movie: $e');
    }
  }

  // Fetch favorite movies
  Future<List<Map<String, dynamic>>> getFavMovies() async {
    final QuerySnapshot snapshot = await _firestore.collection('movies').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Remove movie by title
  Future<void> removeMovieByTitle(String title) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('movies')
        .where('title', isEqualTo: title)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Inside FirestoreService class
  Future<void> removeMovieById(String movieId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('movies')
        .where('id', isEqualTo: movieId)
        .get();
    log(snapshot.docs.toString());
    // for (var doc in snapshot.docs) {
    //   await doc.reference.delete();
    // }
  }
}
