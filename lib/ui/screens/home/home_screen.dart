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

  void _showTopUpSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TopUpSheet(parentContext: context),
    );
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _Header(
              greeting: _greeting,
              cartCount: cart.totalItems,
              onCartTap: () => Navigator.pushNamed(context, '/order-summary'),
              onNotifTap: () {},
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _BalanceCard(
                onTopUp: _showTopUpSheet,
                onQr: () => Navigator.pushNamed(context, '/qr'),
                onHistory: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionHeader(title: 'Meal Passes'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _MealPassCard(
                      title: 'Breakfast',
                      time: '7:00 – 9:00 AM',
                      icon: Icons.wb_sunny_rounded,
                      isActive: true,
                      onTap: () => Navigator.pushNamed(context, '/qr'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MealPassCard(
                      title: 'Lunch',
                      time: '11:00 AM – 1:00 PM',
                      icon: Icons.lunch_dining_rounded,
                      isActive: false,
                      onTap: () => Navigator.pushNamed(context, '/qr'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const _PromoBanner(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionHeader(
                title: "Today's Menu",
                actionLabel: 'View all',
                onAction: () =>
                    Navigator.pushReplacementNamed(context, '/menu'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filterLabels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedFilter == i
                          ? AppTheme.green
                          : ctx.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedFilter == i
                            ? AppTheme.green
                            : ctx.borderColor,
                      ),
                      boxShadow: _selectedFilter == i
                          ? [
                              BoxShadow(
                                color: AppTheme.green.withValues(alpha: 0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      _filterLabels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _selectedFilter == i
                            ? Colors.white
                            : ctx.mutedColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return _FoodCard(
                    item: item,
                    onAdd: () => CartProvider.of(context).add(item),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 1:
              Navigator.pushReplacementNamed(context, '/menu');
            case 2:
              Navigator.pushNamed(context, '/qr');
            case 3:
              Navigator.pushNamed(context, '/history');
            case 4:
              Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.cartCount,
    required this.onCartTap,
    required this.onNotifTap,
  });

  final String greeting;
  final int cartCount;
  final VoidCallback onCartTap;
  final VoidCallback onNotifTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(fontSize: 12, color: context.mutedColor),
                ),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ],
            ),
          ),
          _ActionIcon(icon: Icons.notifications_outlined, onTap: onNotifTap),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _ActionIcon(
                  icon: Icons.shopping_bag_outlined, onTap: onCartTap),
              if (cartCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: context.textColor),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: context.textColor,
          ),
        ),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: const Text(
              'View all',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.onTopUp,
    required this.onQr,
    required this.onHistory,
  });

  final VoidCallback onTopUp;
  final VoidCallback onQr;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.balanceCardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.42),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -28,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 44,
            bottom: -18,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'CADT Scholar',
                        style:
                            TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            color: Color(0xFF69F0AE), size: 7),
                        SizedBox(width: 5),
                        Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                '៛65,000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '≈ \$16.25 USD',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _BalanceBtn(
                      label: 'Top Up',
                      icon: Icons.add_rounded,
                      isPrimary: true,
                      onTap: onTopUp,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BalanceBtn(
                      label: 'QR Pay',
                      icon: Icons.qr_code_2,
                      isPrimary: false,
                      onTap: onQr,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BalanceBtn(
                      label: 'History',
                      icon: Icons.receipt_long_rounded,
                      isPrimary: false,
                      onTap: onHistory,
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

class _BalanceBtn extends StatelessWidget {
  const _BalanceBtn({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.white
              : Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isPrimary ? const Color(0xFF2E7D32) : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    isPrimary ? const Color(0xFF2E7D32) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealPassCard extends StatelessWidget {
  const _MealPassCard({
    required this.title,
    required this.time,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String time;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.green : context.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppTheme.green.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.2)
                        : context.surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isActive ? Colors.white : AppTheme.green,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.qr_code_2,
                  size: 18,
                  color: isActive ? Colors.white60 : context.mutedColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isActive ? Colors.white : context.textColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white70 : context.mutedColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : context.borderColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActive ? 'Active' : 'Upcoming',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : context.mutedColor,
                ),
              ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.green.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'EXCLUSIVE OFFER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fresh Daily\nCampus Food',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '20% off for CADT Scholars\nthis week only',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Discount coupon applied!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.green,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Claim Now',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.ramen_dining_rounded,
                color: Colors.white,
                size: 64,
              ),
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
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: _FoodThumbnail(item: item),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFA726), size: 13),
                    const SizedBox(width: 3),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: TextStyle(
                          color: context.mutedColor, fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_shopping_cart_rounded,
                            color: Colors.white, size: 13),
                        SizedBox(width: 5),
                        Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
        child: Icon(kFoodIcons[idx % kFoodIcons.length],
            color: AppTheme.green, size: 52),
      ),
    );
  }
}

class _TopUpSheet extends StatelessWidget {
  const _TopUpSheet({required this.parentContext});

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Top Up Balance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select an amount to add to your wallet',
            style: TextStyle(color: context.mutedColor, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: ['\$5', '\$10', '\$20', '\$50'].map((amt) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('$amt top-up request submitted'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.green,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    amt,
                    style: const TextStyle(
                      color: AppTheme.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SmartCanteenButton(
            label: 'Enter Custom Amount',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
