import '../../dtos/menu_dto.dart';
import 'menu_repository.dart';

class MenuRepositoryMock implements MenuRepository {
  static const _items = [
    MenuItemDto(id: '1', name: 'Khmer Noodle', description: 'Traditional Cambodian noodle soup with fresh herbs', price: 2.00, rating: 4.7, tags: ['Soup', 'Traditional'], session: 'breakfast'),
    MenuItemDto(id: '2', name: 'Pork with Rice', description: 'Steamed jasmine rice with seasoned grilled pork', price: 1.75, rating: 4.8, tags: ['Grilled', 'Sweet'], session: 'lunch'),
    MenuItemDto(id: '3', name: 'Chicken with Rice', description: 'Tender chicken on fragrant jasmine rice with house sauce', price: 2.00, rating: 4.9, tags: ['Soft', 'Sweet'], session: 'lunch'),
    MenuItemDto(id: '4', name: 'Fried Egg Rice', description: 'Sunny-side-up egg over warm jasmine rice with soy sauce', price: 1.25, rating: 4.5, tags: ['Simple', 'Quick'], session: 'breakfast'),
    MenuItemDto(id: '5', name: 'Coconut Milk Tea', description: 'Creamy iced milk tea with coconut jelly and brown sugar', price: 1.00, rating: 4.6, tags: ['Cold', 'Sweet'], session: 'drinks'),
    MenuItemDto(id: '6', name: 'Sugarcane Juice', description: 'Freshly pressed sugarcane juice with a hint of lime', price: 0.75, rating: 4.4, tags: ['Cold', 'Fresh'], session: 'drinks'),
    MenuItemDto(id: '7', name: 'Bai Sach Chrouk', description: 'Cambodian breakfast of marinated pork on rice', price: 1.50, rating: 4.8, tags: ['Grilled', 'Traditional'], session: 'breakfast'),
    MenuItemDto(id: '8', name: 'Beef Lok Lak', description: 'Stir-fried beef cubes with lime dipping sauce and fried egg', price: 3.00, rating: 4.9, tags: ['Stir-fried', 'Savory'], session: 'lunch'),
  ];

  @override
  Future<List<MenuItemDto>> getWeeklyMenu() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _items;
  }

  @override
  Future<List<MenuItemDto>> getMenuBySession(String session) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _items.where((i) => i.session == session).toList();
  }
}
