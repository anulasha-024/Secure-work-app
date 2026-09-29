// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.accountName = "Account Name"});
  final String accountName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _filter = 'All';
  final _searchCtrl = TextEditingController();

  // Cards 1–4 (order matches your screenshot)
  final List<Map<String, String>> _categories = const [
    {'name': 'Tutorials',        'img': 'images/tutorials_icon.png'},
    {'name': 'Quizzes',          'img': 'images/quizzes_icon.png'},
    {'name': 'Policies',         'img': 'images/policies_icon.png'},
    {'name': 'Security Updates', 'img': 'images/security_icon.png'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // Map a category name to a route
  String? _routeForCategory(String name) {
    switch (name) {
      case 'Tutorials':        return '/tutorials';
      case 'Quizzes':          return '/quizzes';
      case 'Policies':         return '/policies';
      case 'Security Updates': return '/security-updates';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F7F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroGreeting(
                name: widget.accountName,
                searchCtrl: _searchCtrl,
                filter: _filter,
                onFilterChanged: (v) => setState(() => _filter = v),
                // (6) Bell → Notifications
                onBellTap: () => Navigator.pushNamed(context, '/notifications'),
              ),
              const SizedBox(height: 18),

              const Text(
                'Explore categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, i) {
                  final c = _categories[i];
                  return _CategoryCard(
                    title: c['name']!,
                    image: c['img']!,
                    onTap: () {
                      final route = _routeForCategory(c['name']!);
                      if (route != null) Navigator.pushNamed(context, route);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Bottom pill nav: 0=Home, 1=Notifications, 2=Profile
      bottomNavigationBar: _BottomPillNav(
        current: 0,
        onTap: (i) {
          if (i == 0) return; // already on Home
          if (i == 1) Navigator.pushReplacementNamed(context, '/notifications'); // (6)
          if (i == 2) Navigator.pushReplacementNamed(context, '/profile');       // (5)
        },
      ),
    );
  }
}

/// ===== Hero/Greeting card (dark rounded, with bell + search pill) =====
class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting({
    required this.name,
    required this.searchCtrl,
    required this.filter,
    required this.onFilterChanged,
    required this.onBellTap,
  });

  final String name;
  final TextEditingController searchCtrl;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF4B4B52),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF595A63), Color(0xFF3F4046)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hello',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onBellTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDADADC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none,
                          size: 20, color: Colors.white),
                    ),
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5065),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),

          // Search pill with dropdown
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      // TODO: trigger search
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.only(left: 8),
                  child: _FilterChip(
                    value: filter,
                    onChanged: onFilterChanged,
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

/// Little rounded dropdown on the right side of the search pill
class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down),
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All')),
            DropdownMenuItem(value: 'Tutorials', child: Text('Tutorials')),
            DropdownMenuItem(value: 'Quizzes', child: Text('Quizzes')),
            DropdownMenuItem(value: 'Policies', child: Text('Policies')),
            DropdownMenuItem(value: 'Security', child: Text('Security')),
          ],
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

/// ===== Category card (white rounded with image + title) =====
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 6),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 74, height: 74, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Bottom rounded pill navigation (Home | Bell | Person) =====
class _BottomPillNav extends StatelessWidget {
  const _BottomPillNav({
    required this.current,
    required this.onTap,
  });

  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 16),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _NavItem(
              icon: current == 0 ? Icons.home : Icons.home_outlined,
              label: 'Home',
              active: current == 0,
              onTap: () => onTap(0),
            ),
            const Spacer(),
            _NavItem(
              icon: current == 1 ? Icons.notifications : Icons.notifications_none,
              label: '',
              active: current == 1,
              onTap: () => onTap(1), // (6) Notifications
            ),
            const Spacer(),
            _NavItem(
              icon: current == 2 ? Icons.person : Icons.person_outline,
              label: '',
              active: current == 2,
              onTap: () => onTap(2), // (5) Profile
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.onTap,
    required this.active,
    this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: EdgeInsets.symmetric(
        horizontal: label == null || label!.isEmpty ? 12 : 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8ECF7) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87),
          if (label != null && label!.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label!, style: const TextStyle(fontWeight: FontWeight.w600)),
          ]
        ],
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: chip,
    );
  }
}
