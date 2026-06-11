import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  static const routeName = '/menu';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedFilter = 0;
  final List<String> filters = ['All', 'Breakfast', 'Lunch', 'Drinks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Canteen',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/order-summary'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find your favorite food',
                prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(filters.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedFilter = index),
                    child: MenuChip(
                      label: filters[index],
                      selected: selectedFilter == index,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const FoodItemCard();
              },
            ),
          ),
          const BottomSummaryBar(),
        ],
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) return; // Already here
          // Add other navigations here when screens are ready
        },
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FancyCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFF7E4C1),
              ),
              child: const Icon(Icons.restaurant_menu, color: AppTheme.green, size: 40),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Fried Pork with Rice',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          const Text(
                            '4.8',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Thinly sliced pork cuts marinated in palm sugar, garlic, fish sauce...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: ['Sweet', 'Grilled', 'Spicy'].map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(fontSize: 9, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                        ),
                      ).animateFade();
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '\$1.75',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.green,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 30,
                        child: SmartCanteenButton(
                          label: 'Add',
                          onPressed: () {},
                          height: 30,
                          radius: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSummaryBar extends StatelessWidget {
  const BottomSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2 items',
                style: TextStyle(fontSize: 12, color: AppTheme.mutedText),
              ),
              const Text(
                '\$3.75',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.green,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SmartCanteenButton(
              label: 'View Cart',
              onPressed: () => Navigator.pushNamed(context, '/order-summary'),
              height: 48,
              radius: 12,
              fillColor: AppTheme.accentBlue,
              textColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SmartCanteenButton(
              label: 'Checkout',
              onPressed: () {},
              height: 48,
              radius: 12,
            ),
          ),
        ],
      ),
    );
  }
}

extension AnimationExt on Widget {
  Widget animateFade() => this; // Placeholder for future animation
}
