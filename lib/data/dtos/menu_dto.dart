class MenuItemDto {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final List<String> tags;
  final String session; // 'breakfast' | 'lunch' | 'drinks'
  final String? imageUrl;

  const MenuItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.tags,
    required this.session,
    this.imageUrl,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) => MenuItemDto(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        tags: List<String>.from(json['tags'] as List),
        session: json['session'] as String,
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'rating': rating,
        'tags': tags,
        'session': session,
        'image_url': imageUrl,
      };
}
