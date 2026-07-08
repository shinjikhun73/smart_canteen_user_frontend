/// Mirrors a backend `MenuItem` (`GET /menu-items`). Prices arrive as decimal
/// strings; the backend has no ratings/tags/images, so the app supplies those
/// visually (gradient + icon placeholders).
class MenuItemDto {
  final String id;
  final String name;
  final String description;
  final double price;

  /// Category name (e.g. "Breakfast", "Lunch", "Drinks"), or null if uncategorised.
  final String? categoryName;
  final String availabilityStatus;

  /// The school this item belongs to — the tenant an order for it is scoped to.
  final String? schoolId;

  const MenuItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryName,
    required this.availabilityStatus,
    required this.schoolId,
  });

  factory MenuItemDto.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return MenuItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      price: _toDouble(json['price']),
      categoryName:
          category is Map<String, dynamic> ? category['name'] as String? : null,
      availabilityStatus: json['availability_status'] as String? ?? 'available',
      schoolId: json['school_id'] as String?,
    );
  }

  static double _toDouble(dynamic value) => switch (value) {
        num n => n.toDouble(),
        String s => double.tryParse(s) ?? 0.0,
        _ => 0.0,
      };
}
