import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_catalogue/data/models/product_model.dart';

void main() {
  group('Product Model JSON Parsing Test', () {
    test('fromJSON should correctly convert a valid JSON map into a Product object', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'title': 'Test Product',
        'description': 'This is a test product description.',
        'price': 99.99,
        'rating': 4.5,
        'thumbnail': 'https://example.com/thumbnail.png',
        'images': ['https://example.com/image1.png'],
      };

      final product = Product.fromJson(jsonMap);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.description, 'This is a test product description.');
      expect(product.price, 99.99);
      expect(product.rating, 4.5);
      expect(product.thumbnail, 'https://example.com/thumbnail.png');
      expect(product.images, ['https://example.com/image1.png']);
    });
  });
}