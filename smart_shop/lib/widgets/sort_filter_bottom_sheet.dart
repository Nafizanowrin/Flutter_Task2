import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart'; 

class SortFilterBottomSheet extends StatelessWidget {
  const SortFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Sort by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          _buildSortOption(
            context,
            'None',
            SortType.none, 
            productProvider.sortType == SortType.none,
            (type) => productProvider.setSortType(type),
          ),
          _buildSortOption(
            context,
            'Price: Low to High',
            SortType.priceLowToHigh, // Use the enum here
            productProvider.sortType == SortType.priceLowToHigh,
            (type) => productProvider.setSortType(type),
          ),
          _buildSortOption(
            context,
            'Price: High to Low',
            SortType.priceHighToLow, // Use the enum here
            productProvider.sortType == SortType.priceHighToLow,
            (type) => productProvider.setSortType(type),
          ),
          _buildSortOption(
            context,
            'Rating',
            SortType.rating, // Use the enum here
            productProvider.sortType == SortType.rating,
            (type) => productProvider.setSortType(type),
          ),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
              
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    SortType sortType, // Correctly reference the enum
    bool isSelected,
    Function(SortType) onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return RadioListTile<SortType>( // Use the enum type for RadioListTile
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      value: sortType,
      groupValue: isSelected ? sortType : null, // Set groupValue based on isSelected
      onChanged: (SortType? value) { // Nullable value for onChanged
        if (value != null) {
          onTap(value);
        }
      },
      activeColor: colorScheme.primary,
    );
  }
}