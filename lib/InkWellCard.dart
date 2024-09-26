 import 'package:flutter/material.dart';

import 'Movie Card.dart';

class Inkwellcard extends StatelessWidget {

  final double rating;
  final String title;
  final String year;
  final String duration;
  final String image;

Inkwellcard({
  required this.image,
  required this.rating,
  required this.title,
  required this.year,
  required this.duration,
}){}
   @override
   Widget build(BuildContext context) {
     return InkWell(onTap: (){},
       child: MovieCard(
         image: image,
         rating: rating,
         title: title,
         year: year,
         duration: duration,
       ),);

   }
 }
