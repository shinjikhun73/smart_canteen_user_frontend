import 'package:flutter/material.dart';

import '../../../models/cart_model.dart';
import '../../../models/food_item.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;

  static const _filterLabels = ['All', 'Breakfast', 'Lunch', 'Drinks'];
  static const _filterCats = ['', 'breakfast', 'lunch', 'drinks'];

  List<FoodItem> get _filteredItems {
    final cat = _filterCats[_selectedFilter];
    final items = cat.isEmpty
        ? kMenuItems
        : kMenuItems.where((f) => f.category == cat).toList();
    return items.take(4).toList();
  }

  void _showTopUpDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Top Up Balance',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.green),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select amount to top up:', style: TextStyle(color: AppTheme.mutedText)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['\$5', '\$10', '\$20', '\$50'].map((amt) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$amt top-up request submitted'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.green,
                      ),
                    );
                  },
                  child: Container(
                    width: 72,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4FFE9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      amt,
                      style: const TextStyle(
                        color: AppTheme.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.mutedText)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Hello, John!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.green,
                    ),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/order-summary'),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppTheme.green,
                      ),
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 12),
            _BalanceCard(
              width: MediaQuery.sizeOf(context).width,
              onTopUp: _showTopUpDialog,
              onQr: () => Navigator.pushNamed(context, '/qr'),
            ),
            const SizedBox(height: 18),
            const _SectionHeader(title: 'Active Coupons'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CouponCard(
                    title: 'Breakfast',
                    time: '7:00 am – 9:00 am',
                    icon: Icons.wb_sunny_outlined,
                    onTap: () => Navigator.pushNamed(context, '/qr'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CouponCard(
                    title: 'Lunch',
                    time: '11:00 am – 1:00 pm',
                    icon: Icons.lunch_dining_outlined,
                    onTap: () => Navigator.pushNamed(context, '/qr'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _PromoBanner(),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: _SectionHeader(title: "Today's Menu")),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/menu'),
                  child: const Text(
                    'View More >>',
                    style: TextStyle(color: AppTheme.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filterLabels.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: i < _filterLabels.length - 1 ? 10 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = i),
                      child: MenuChip(
                        label: _filterLabels[i],
                        selected: _selectedFilter == i,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
                final items = _filteredItems;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _FoodCard(
                      item: item,
                      onAdd: () => CartProvider.of(context).add(item),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 1: Navigator.pushReplacementNamed(context, '/menu');
            case 2: Navigator.pushNamed(context, '/qr');
            case 3: Navigator.pushNamed(context, '/history');
            case 4: Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.width,
    required this.onTopUp,
    required this.onQr,
  });

  final double width;
  final VoidCallback onTopUp;
  final VoidCallback onQr;

  @override
  Widget build(BuildContext context) {
    return FancyCard(
      radius: 18,
      backgroundColor: const Color(0xFFF4FFE9),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -14,
            child: Opacity(
              opacity: 0.18,
              child: CanteenLogo(size: width * 0.34),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '៛65,000',
                style: TextStyle(
                  color: AppTheme.green,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '~\$16.25',
                style: TextStyle(color: AppTheme.green, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SmartCanteenButton(
                      label: 'Top Up',
                      onPressed: onTopUp,
                      height: 40,
                      radius: 10,
                      leading: const Icon(Icons.add, size: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onQr,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.qr_code_2, color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.green,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.title,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FancyCard(
        padding: const EdgeInsets.all(12),
        radius: 16,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6EA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.green),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(color: AppTheme.mutedText, fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.qr_code_2, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return FancyCard(
      padding: const EdgeInsets.all(12),
      radius: 18,
      backgroundColor: AppTheme.green,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fresh Daily Campus Food',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Exclusive 20% Discount for\nCADT Scholars this week',
                  style: TextStyle(color: Colors.white, fontSize: 11, height: 1.35),
                ),
                const SizedBox(height: 12),
                SmartCanteenButton(
                  label: 'Claim Now',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Discount coupon applied!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.green,
                    ),
                  ),
                  height: 34,
                  radius: 10,
                  fillColor: Colors.white,
                  textColor: AppTheme.green,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDF2D9), Color(0xFFF9F5D7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.ramen_dining, color: AppTheme.green, size: 58),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.item, required this.onAdd});

  final FoodItem item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return FancyCard(
      padding: const EdgeInsets.all(10),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _FoodThumbnail(item: item),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(color: AppTheme.text, fontSize: 11),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: SmartCanteenButton(
              label: 'Add',
              onPressed: onAdd,
              height: 30,
              radius: 8,
              leading: const Icon(Icons.add_shopping_cart, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodThumbnail extends StatelessWidget {
  const _FoodThumbnail({required this.item});

  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    if (item.imagePath != null) {
      return Image.asset(
        item.imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    final idx = item.colorSeed % kFoodGradients.length;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kFoodGradients[idx],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(kFoodIcons[idx % kFoodIcons.length], color: AppTheme.green, size: 52),
      ),
    );
  }
}
