class Product {
  final int id;
  final String title;
  final String resume;
  final String content;

  Product({this.id, this.title, this.resume, this.content});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      resume: json['resume'] as String,
      content: json['content'] as String
    );
  }
}