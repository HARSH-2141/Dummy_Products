class Category {
  final String name;
  final String slug;
  final String url;

  Category({required this.name, required this.slug, required this.url});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      slug: json['slug'],
      url: json['url'],
    );
  }
}
