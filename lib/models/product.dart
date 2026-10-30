import 'package:flutter/material.dart';

enum IllustrationType { plate, bowl, glass }

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.price,
    required this.description,
    required this.illustration,
    required this.background,
    required this.foodColor,
    required this.accent,
    this.oldPrice,
    this.reviews = 120,
    this.image,
  });

  final String id;
  final String name;
  final String category;
  final double rating;
  final int price;
  final int? oldPrice;
  final int reviews;
  final String description;
  final IllustrationType illustration;
  final Color background;
  final Color foodColor;
  final Color accent;
  final String? image;  // tambahkan di daftar field
}
