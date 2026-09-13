class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;
  final List<Review> reviews;

Product({
  required this.id,
  required this.title,
  required this.description,
  required this.price,
  required this.rating,
  required this.thumbnail,
  required this.images,
  required this.reviews,
});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available.',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
    rating: json['rating'] as int? ?? 0,
    comment: json['comment'] as String? ?? '',
    date: json['date'] as String? ?? '',
    reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
    reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }
}
