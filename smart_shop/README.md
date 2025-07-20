# Flutter_Task2 – Smart Shop 🛍️

A Flutter-based shopping app prototype showcasing product listings, search/filter capabilities, and a clean, user-friendly interface.

## 🚀 Features

- **Product catalogue**: Browse a list/grid of items with images, names, prices.
- **Search & filter**: Quickly find items by name/category.
- **Product details**: View individual item details including price, description, and image.
- **Responsive UI**: Adapts to different screen sizes.
- Easily extensible to include cart, checkout, authentication, etc.

## 💾 Tech Stack

- **Flutter** (Dart)
- Core packages:
  - `flutter/material.dart` – UI elements
  - `provider` – State management
  - `http` – API/data fetching (if applicable)
- Optional:
  - `cached_network_image` – Efficient image loading & caching
  - `flutter_bloc` or `riverpod` – Alternative state-management solutions

## 🛠️ Project Structure

lib/
├── main.dart # Entry point
├── models/ # Data models (e.g. Product)
├── providers/ # State management (e.g. ProductProvider)
├── screens/ # UI pages
│ ├── home_screen.dart
│ └── product_detail_screen.dart
├── widgets/ # Reusable UI components
│ ├── product_item.dart
│ └── product_grid.dart
assets/
└── images/ # Local image files (optional)
pubspec.yaml # Project dependencies & assets
