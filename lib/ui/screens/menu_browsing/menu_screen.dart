import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/cart_model.dart';
import '../../../models/food_item.dart';
import '../../../theme/app_theme.dart';
import '../../../ui/states/balance_state.dart';
import '../../../ui/states/order_history_state.dart';
import '../../widgets/cart_bar.dart';
import '../../widgets/payment_method_sheet.dart';
import '../../widgets/smart_canteen_widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  static const routeName = '/menu';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedFilter = 0;
  String _search = '';

  static const _filters = ['All', 'Breakfast', 'Lunch', 'Drinks'];
  static const _cats = ['', 'breakfast', 'lunch', 'drinks'];

  List<FoodItem> get _visibleItems {
    final cat = _cats[_selectedFilter];
    return kMenuItems.where((f) {
      final matchCat = cat.isEmpty || f.category == cat;
      final matchSearch =
          _search.isEmpty ||
          f.name.toLowerCase().contains(_search.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
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
            final orderId = DateTime.now().millisecondsSinceEpoch.toString();
            final order = OrderRecord(
              id: orderId,
              date: _formatDate(DateTime.now()),
              items: items,
              total: cart.total,
              status: 'Pending',
              session: 'Lunch',
              imagePath: cart.entries.isNotEmpty ? cart.entries.first.item.imagePath : null,
              colorSeed: cart.entries.isNotEmpty ? cart.entries.first.item.colorSeed : 0,
            );

            orderHistory.addOrder(order);
            cart.clear();

            Future.delayed(const Duration(seconds: 7), () {
              orderHistory.updateOrderStatus(orderId, 'Completed');
            });

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
    final items = _visibleItems;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Smart Canteen',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.pushNamed(context, '/order-summary'),
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
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Find your favorite food',
                prefixIcon: Icon(Icons.search, color: AppTheme.mutedText),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_filters.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: MenuChip(
                      label: _filters[i],
                      selected: _selectedFilter == i,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppTheme.border,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No items found',
                          style: TextStyle(color: AppTheme.mutedText),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return FoodItemCard(
                        item: items[index],
                        onAdd: () => cart.add(items[index]),
                      );
                    },
                  ),
          ),
          CartBar(
            onViewCart: () => Navigator.pushNamed(context, '/order-summary'),
            onCheckout: () => _showCheckoutSheet(context),
          ),
        ],
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({super.key, required this.item, required this.onAdd});

  final FoodItem item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FancyCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: 100,
                child: _FoodImage(item: item),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: item.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
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
                          onPressed: onAdd,
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

class _FoodImage extends StatelessWidget {
  const _FoodImage({required this.item});
  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    if (item.imagePath != null) {
      return Image.asset(
        item.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    final idx = item.colorSeed % kFoodGradients.length;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kFoodGradients[idx],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          kFoodIcons[idx % kFoodIcons.length],
          color: AppTheme.green,
          size: 40,
        ),
      ),
    );
  }
}
