import 'package:flutter/material.dart';

class Product {
  final String image, title, description;
  final int price, size, id;
  final Color color;
  Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
  });
}

List<Product> products = [
  Product(
      id: 1,
      title: "Product Name",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/o1.jpg",
      color: Color(0xFF3D82AE)),
  Product(
      id: 2,
      title: "Product Name",
      price: 234,
      size: 8,
      description: dummyText,
      image: "assets/o2.jpg",
      color: Color(0xFFD3A984)),
  Product(
      id: 3,
      title: "Product Name",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/o3.jpg",
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Product Name",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/o4.jpg",
      color: Color(0xFFE6B398)),
  Product(
      id: 5,
      title: "Product Name",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/o5.jpg",
      color: Color(0xFFFB7883)),
  Product(
    id: 6,
    title: "Product Name",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/o5.jpg",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText = "Someting description for this product";
