import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cart_model.dart';
import '../../../models/food_item.dart';
import '../../../theme/app_theme.dart';
import '../../../ui/states/balance_state.dart';
import '../../../ui/states/order_history_state.dart';
import '../../../ui/utils/async_value.dart';
import '../../../ui/utils/currency_formatter.dart';
import '../../widgets/cart_bar.dart';
import '../../widgets/payment_method_sheet.dart';
import '../../widgets/smart_canteen_widgets.dart';
import '../shell/app_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BalanceState>().fetchBalance();
    });
  }

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

  void _showCheckoutSheet(BuildContext context) {
    final cart = CartProvider.of(context);
    final balanceState = context.read<BalanceState>();
    final orderHistory = context.read<OrderHistoryState>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentMethodSheet(
        totalAmount: cart.total,
        onConfirm: (paymentMethod) async {
          try {
            if (paymentMethod == 'SC') {
              await balanceState.payment(cart.total);
            }

            final items = cart.entries.map((e) => e.item.name).join(', ');
            final order = OrderRecord(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: _formatDate(DateTime.now()),
              items: items,
              total: cart.total,
              status: 'Completed',
              session: 'Lunch',
              imagePath: cart.entries.isNotEmpty ? cart.entries.first.item.imagePath : null,
              colorSeed: cart.entries.isNotEmpty ? cart.entries.first.item.colorSeed : 0,
            );

            orderHistory.addOrder(order);
            cart.clear();

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Payment successful! Order added to history.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.green,
                duration: Duration(seconds: 2),
              ),
            );
          } catch (e) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Payment failed: $e'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFFE53935),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
    }
    return '${dt.month}/${dt.day}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                      onQr: () => AppShellScope.maybeOf(context)?.setTab(2),
                      onHistory: () => AppShellScope.maybeOf(context)?.setTab(3),
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
                    child: _MealPassRow(
                      onTap: () => AppShellScope.maybeOf(context)?.setTab(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const _PromoBanner(),
                  ),
                  const SizedBox(height: 24),
                  _MenuSection(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (i) => setState(() => _selectedFilter = i),
                    filteredItems: _filteredItems,
                    filterLabels: _filterLabels,
                    onViewAll: () => AppShellScope.maybeOf(context)?.setTab(1),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            CartBar(
              onViewCart: () => Navigator.pushNamed(context, '/order-summary'),
              onCheckout: () => _showCheckoutSheet(context),
            ),
          ],
        ),
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
    final balanceUsd = context.watch<BalanceState>().balanceUsd;
    final String khrText;
    final String usdText;
    if (balanceUsd case AsyncData<double>(:final data)) {
      khrText = CurrencyFormatter.usdToKhr(data);
      usdText = '≈ ${CurrencyFormatter.formatUSD(data)} USD';
    } else if (balanceUsd is AsyncError) {
      khrText = '--';
      usdText = 'Error loading balance';
    } else {
      khrText = '···';
      usdText = 'Loading…';
    }

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
              Text(
                khrText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                usdText,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
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

class _MealPassRow extends StatelessWidget {
  const _MealPassRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MealPassCard(
            title: 'Breakfast',
            time: '7:00 – 9:00 AM',
            icon: Icons.wb_sunny_rounded,
            isActive: true,
            onTap: onTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MealPassCard(
            title: 'Lunch',
            time: '11:00 AM – 1:00 PM',
            icon: Icons.lunch_dining_rounded,
            isActive: false,
            onTap: onTap,
          ),
        ),
      ],
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

class _MenuFilterChip extends StatelessWidget {
  const _MenuFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.green : context.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.green : context.borderColor,
          ),
          boxShadow: isSelected
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
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : context.mutedColor,
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filteredItems,
    required this.filterLabels,
    required this.onViewAll,
  });

  final int selectedFilter;
  final ValueChanged<int> onFilterChanged;
  final List<FoodItem> filteredItems;
  final List<String> filterLabels;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SectionHeader(
            title: "Today's Menu",
            actionLabel: 'View all',
            onAction: onViewAll,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: filterLabels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _MenuFilterChip(
              label: filterLabels[i],
              isSelected: selectedFilter == i,
              onTap: () => onFilterChanged(i),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return _FoodCard(
                item: item,
                onAdd: () => CartProvider.of(context).add(item),
              );
            },
          ),
        ),
      ],
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

class _TopUpAmountTile extends StatelessWidget {
  const _TopUpAmountTile({required this.amount, required this.onTap});

  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.borderColor),
        ),
        alignment: Alignment.center,
        child: Text(
          amount,
          style: const TextStyle(
            color: AppTheme.green,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
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
              return _TopUpAmountTile(
                amount: amt,
                onTap: () {
                  final val = double.parse(amt.substring(1));
                  Navigator.pop(context);
                  _doTopUp(parentContext, val, amt);
                },
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

// ── Top-up async helpers ──────────────────────────────────────────────────────

Future<void> _doTopUp(BuildContext ctx, double amount, String label) async {
  showDialog<void>(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => _ProcessingDialog(amountLabel: label),
  );

  bool success = true;
  try {
    await ctx.read<BalanceState>().topUp(amount);
  } catch (_) {
    success = false;
  }

  if (!ctx.mounted) return;
  Navigator.of(ctx).pop(); // dismiss processing dialog
  if (!ctx.mounted) return;

  ctx.read<OrderHistoryState>().addOrder(
    OrderRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _formatNow(),
      items: 'Wallet Top-up',
      total: amount,
      status: success ? 'Completed' : 'Failed',
      type: 'deposit',
    ),
  );

  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: success ? AppTheme.green : const Color(0xFFE53935),
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle_rounded : Icons.error_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              success
                  ? '$label top-up successful!'
                  : 'Top-up failed. Please try again.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ),
  );
}

String _formatNow() {
  final dt = DateTime.now();
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return 'Today, $h:$m $period';
}

// ── Processing dialog ─────────────────────────────────────────────────────────

class _ProcessingDialog extends StatefulWidget {
  const _ProcessingDialog({required this.amountLabel});

  final String amountLabel;

  @override
  State<_ProcessingDialog> createState() => _ProcessingDialogState();
}

class _ProcessingDialogState extends State<_ProcessingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.88, end: 1.12)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppTheme.green,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              color: AppTheme.green,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Processing ${widget.amountLabel}…',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Please wait a moment',
            style: TextStyle(fontSize: 12, color: context.mutedColor),
          ),
        ],
      ),
    );
  }
}
