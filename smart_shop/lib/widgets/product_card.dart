import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? Colors.grey[900] : Color(0xFFFFF8E1), // Beige Tint
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black38 : Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          widget.product.image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 30, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, child) {
                            final isFavorite = favoritesProvider.isFavorite(widget.product.id);
                            return GestureDetector(
                              onTap: () {
                                favoritesProvider.toggleFavorite(widget.product);
                                _animationController.forward(from: 0.0);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isFavorite ? Color(0xFFF57C00) : Colors.grey[700],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF4E342E), 
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              height: 1.1,
                              color: Colors.brown[900], 
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: widget.product.rating.rate,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 10.0,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '(${widget.product.rating.count})',
                                style: TextStyle(
                                  color: Colors.brown[200],
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context, listen: false)
                                    .addItem(widget.product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${widget.product.title} added to cart'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Color(0xFF4E342E),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF57C00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_shopping_cart, size: 12),
                                  SizedBox(width: 2),
                                  Text(
                                    'Add',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}