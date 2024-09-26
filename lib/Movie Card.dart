
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {

  final double rating;
  final String title;
  final String year;
  final String duration;
  final String image;

  MovieCard({
    required this.image,
    required this.rating,
    required this.title,
    required this.year,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Card width
      margin: EdgeInsets.all(8), // Margin around each card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        color: Colors.grey[850], // Background color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("$image",
                  height: 170, // Image height
                  width: 150, // Image width matches card width
                  fit: BoxFit.cover, // Fit image within container
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24, // Add icon in the top-right corner
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '$year  $duration',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
