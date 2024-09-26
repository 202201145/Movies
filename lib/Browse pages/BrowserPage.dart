import 'package:flutter/material.dart';
import 'CategoryDetailScreen.dart';
import 'apl client.dart';

class BrowseScreen extends StatelessWidget {
  static const routeName = '/browse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Browse Categories', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: ApiClient().fetchCategories(), // Fetch categories
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found', style: TextStyle(color: Colors.white)));
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(
                          category: categories[index]['name']!,
                          categoryId: categories[index]['id']!,
                        ),
                      ),
                    );
                  },
                  child: CategoryCard(
                    category: categories[index]['name']!,
                    imagePath: categories[index]['image']!,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final String imagePath;

  CategoryCard({required this.category, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, color: Colors.red);
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.5),
          child: Text(
            category,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
