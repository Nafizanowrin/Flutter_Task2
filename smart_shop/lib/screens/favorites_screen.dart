import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF3E0),
        iconTheme: IconThemeData(color: Colors.brown),
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.brown[200],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[300],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add products to your favorites',
                    style: TextStyle(
                      color: Colors.brown[200],
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: favoritesProvider.favorites[index],
              );
            },
          );
        },
      ),
    );
  }
}
