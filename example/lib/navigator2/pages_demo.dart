import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

/// Navigator 2.0 without a router: the page stack is a function of state.
///
/// * Selecting a product adds its page; clearing the selection removes it.
/// * "Next product" changes the product but keeps the page key, so the page
///   is updated in place — no new transition.
/// * The back button (AppBar or system) pops the top page, and
///   [Navigator.onDidRemovePage] writes that back into state.
class PagesDemo extends StatefulWidget {
  const PagesDemo({super.key});

  static const products = ['Coffee', 'Tea', 'Juice', 'Water'];

  @override
  State<PagesDemo> createState() => _PagesDemoState();
}

class _PagesDemoState extends State<PagesDemo> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  int? _selected;
  bool _showReviews = false;

  static const _listKey = ValueKey('list');
  static const _productKey = ValueKey('product');
  static const _reviewsKey = ValueKey('reviews');

  void _onDidRemovePage(Page<Object?> page) {
    setState(() {
      if (page.key == _reviewsKey) {
        _showReviews = false;
      } else if (page.key == _productKey) {
        _selected = null;
        _showReviews = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    // The nested Navigator gets system back first; when only the list is
    // left, the pop falls through and leaves the demo.
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onDidRemovePage: _onDidRemovePage,
        pages: [
          NavPage<void>(
            key: _listKey,
            navAni: NavAni.fade,
            child: _ProductListPage(
              onSelect: (index) => setState(() => _selected = index),
            ),
          ),
          if (selected != null)
            NavPage<void>(
              key: _productKey,
              navAni: NavAni.bottom,
              child: _ProductPage(
                name: PagesDemo.products[selected],
                onNext: () => setState(() =>
                    _selected = (selected + 1) % PagesDemo.products.length),
                onReviews: () => setState(() => _showReviews = true),
              ),
            ),
          if (selected != null && _showReviews)
            NavPage<void>(
              key: _reviewsKey,
              navAni: NavAni.ripple,
              child: _ReviewsPage(name: PagesDemo.products[selected]),
            ),
        ],
      ),
    );
  }
}

class _ProductListPage extends StatelessWidget {
  const _ProductListPage({required this.onSelect});

  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator.pages'),
        // This page is the root of the nested Navigator, so leaving the demo
        // pops the outer (app) navigator.
        leading: IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: ListView(
        children: [
          for (final (index, name) in PagesDemo.products.indexed)
            ListTile(
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onSelect(index),
            ),
        ],
      ),
    );
  }
}

class _ProductPage extends StatelessWidget {
  const _ProductPage({
    required this.name,
    required this.onNext,
    required this.onReviews,
  });

  final String name;
  final VoidCallback onNext;
  final VoidCallback onReviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            OutlinedButton(
                onPressed: onNext, child: const Text('Next product')),
            FilledButton(onPressed: onReviews, child: const Text('Reviews')),
          ],
        ),
      ),
    );
  }
}

class _ReviewsPage extends StatelessWidget {
  const _ReviewsPage({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name reviews')),
      body: const Center(child: Text('★★★★☆')),
    );
  }
}
