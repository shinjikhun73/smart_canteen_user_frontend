import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/smart_canteen_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppTheme.green,
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 12),
            _BalanceCard(
              width: MediaQuery.sizeOf(context).width,
              onTopUp: () {},
            ),
            const SizedBox(height: 18),
            const _SectionHeader(title: 'Active Coupons'),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _CouponCard(
                    title: 'Breakfast',
                    time: '7:00 am - 9:00 am',
                    icon: Icons.wb_sunny_outlined,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CouponCard(
                    title: 'Lunch',
                    time: '11:00 am - 1:00 pm',
                    icon: Icons.lunch_dining_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _PromoBanner(),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: _SectionHeader(title: 'Today\'s Menu')),
                TextButton(
                  onPressed: () {},
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
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedFilter = 0),
                    child: MenuChip(
                      label: 'All',
                      selected: selectedFilter == 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => selectedFilter = 1),
                    child: MenuChip(
                      label: 'Breakfast',
                      selected: selectedFilter == 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => selectedFilter = 2),
                    child: MenuChip(
                      label: 'Lunch',
                      selected: selectedFilter == 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => selectedFilter = 3),
                    child: MenuChip(
                      label: 'Drinks',
                      selected: selectedFilter == 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    return const _FoodCard();
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SmartCanteenNavigationBarButton(
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() => selectedTab = index);
          if (index == 1) Navigator.pushReplacementNamed(context, '/menu');
        },
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.width, required this.onTopUp});

  final double width;
  final VoidCallback onTopUp;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
                      leading: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_2,
                      color: Colors.white,
                      size: 26,
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
  });

  final String title;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FancyCard(
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
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 10,
                  ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 106,
                  child: SmartCanteenButton(
                    label: 'Claim Now',
                    onPressed: () {},
                    height: 34,
                    radius: 10,
                    fillColor: Colors.white,
                    textColor: AppTheme.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDF2D9), Color(0xFFF9F5D7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.ramen_dining,
                color: AppTheme.green,
                size: 58,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard();

  @override
  Widget build(BuildContext context) {
    return FancyCard(
      padding: const EdgeInsets.all(10),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7E4C1),
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8DFAF), Color(0xFFF9F4D7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.ramen_dining,
                  color: AppTheme.green,
                  size: 64,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Khmer Noodle',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '\$2.00',
            style: TextStyle(color: AppTheme.text, fontSize: 11),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: SmartCanteenButton(
              label: 'Add',
              onPressed: () {},
              height: 30,
              radius: 8,
              leading: const Icon(
                Icons.add_shopping_cart,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
