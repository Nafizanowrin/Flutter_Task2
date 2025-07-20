import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; 
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/sort_filter_bottom_sheet.dart';
import '../../widgets/trending_card.dart'; 
import 'login_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _appBarAnimationController;
  late Animation<double> _appBarSlideAnimation;

  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  bool _isSearching = false;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _trendingKey = GlobalKey();
  final GlobalKey _hotDealsKey = GlobalKey();
  final GlobalKey _salesKey = GlobalKey();

  // For Hero Banner Carousel
  late PageController _bannerPageController;
  int _currentBannerPageIndex = 0;
  Timer? _bannerTimer;

  // For Trending Now Section Carousel
  late PageController _trendingPageController;
  int _currentTrendingPageIndex = 0;
  Timer? _trendingTimer;


  final Map<String, IconData> _categoryIcons = {
    "electronics": Icons.electrical_services,
    "jewelery": Icons.diamond,
    "men's clothing": Icons.male,
    "women's clothing": Icons.female,
  };

  @override
  void initState() {
    super.initState();
    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _appBarSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _appBarAnimationController, curve: Curves.easeOut),
    );

    _appBarAnimationController.forward();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Initialize PageControllers and start auto-scrolling
    _bannerPageController = PageController(initialPage: _currentBannerPageIndex);
    _startBannerAutoScroll();

    _trendingPageController = PageController(initialPage: _currentTrendingPageIndex);
    _startTrendingAutoScroll(); // Start trending auto-scroll

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        final bannerProducts = productProvider.products
            .where((p) => p.image.isNotEmpty)
            .take(5)
            .toList();

        if (bannerProducts.isNotEmpty) {
          int nextPage = (_currentBannerPageIndex + 1) % bannerProducts.length;
          if (_bannerPageController.hasClients) {
            _bannerPageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }

  void _startTrendingAutoScroll() {
    _trendingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_trendingPageController.hasClients) {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        final trendingProducts = productProvider.products
            .where((p) => p.rating.rate >= 4.0)
            .take(5)
            .toList();

        if (trendingProducts.isNotEmpty) {
          int nextPage = (_currentTrendingPageIndex + 1) % trendingProducts.length;
          if (_trendingPageController.hasClients) {
            _trendingPageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }


  @override
  void dispose() {
    _appBarAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    _trendingPageController.dispose();
    _trendingTimer?.cancel();
    super.dispose();
  }

  // New method for "Need Assistance" dialog
  void _showNeedAssistanceDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Need Assistance?',
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'If you need any help with your shopping or have questions, please contact us:',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.email, color: colorScheme.primary),
                    const SizedBox(width: 10),
                    Text('Email: support@smartshop.com',
                        style: TextStyle(color: colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone, color: colorScheme.primary),
                    const SizedBox(width: 10),
                    Text('Phone: +880 123 456789',
                        style: TextStyle(color: colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Our customer support team is ready to help you!',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // New method for showing Lifetime Membership details
  void _showMembershipDetailsDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Lifetime Membership Benefits',
            style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Unlock a world of exclusive benefits with our Lifetime Membership! Once you become a lifetime member by shopping for \$500 or more, you\'ll receive a special membership card and access to unparalleled advantages:',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                ),
                const SizedBox(height: 15),
                _buildBenefitRow(
                  Icons.discount,
                  'Permanent Discounts:',
                  'Enjoy a fixed percentage off all your purchases, for life!',
                  colorScheme,
                ),
                _buildBenefitRow(
                  Icons.speed,
                  'Early Access:',
                  'Be the first to know about and access new arrivals, flash sales, and special collections.',
                  colorScheme,
                ),
                _buildBenefitRow(
                  Icons.star,
                  'Priority Support:',
                  'Receive dedicated customer service with faster response times and personalized assistance.',
                  colorScheme,
                ),
                _buildBenefitRow(
                  Icons.event,
                  'Exclusive Invitations:',
                  'Get invites to member-only events, product launches, and workshops.',
                  colorScheme,
                ),
                _buildBenefitRow(
                  Icons.card_giftcard,
                  'Birthday Rewards:',
                  'Receive special gifts and additional discounts during your birthday month.',
                  colorScheme,
                ),
                const SizedBox(height: 20),
                Text(
                  'Don\'t miss this opportunity to enhance your SmartShop experience. Your loyalty means everything to us!',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Got It!',
                style: TextStyle(color: colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String description, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.secondary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAnimatedAppBar(context, colorScheme, productProvider),
            SliverToBoxAdapter(child: _buildHeroBanner(context, colorScheme)),
            SliverToBoxAdapter(child: _buildCategories(context, colorScheme)),

            // "For You" section
            SliverToBoxAdapter(child: _buildSectionHeader('🔥 For You', () {})),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: productProvider.isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()))
                  : productProvider.error.isNotEmpty
                      ? SliverToBoxAdapter(
                          child: Center(child: Text(productProvider.error)))
                      : SliverGrid.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: productProvider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                                product: productProvider.filteredProducts[index]);
                          },
                        ),
            ),

            // Existing: Discount Section with conditional card
            SliverToBoxAdapter(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  if (cart.totalAmount >= 500) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('🎉 Special Discount', () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Claim your discount!')));
                        }),
                        const _CustomerDiscountCard(),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink(); // Hide if condition not met
                  }
                },
              ),
            ),

           
            SliverToBoxAdapter(key: _trendingKey, child: _buildSectionHeader('📈 Trending Now', () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View All Trending Products')));
            })),
            SliverToBoxAdapter(child: _buildTrendingProducts(context)),

            
            SliverToBoxAdapter(child: _buildSpecialOffers(context, colorScheme)),

            
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('⭐ Lifetime Membership Offer', () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Learn more about Lifetime Membership!')));
                  }),
                  _MembershipAnnouncementSlider(onLearnMore: () => _showMembershipDetailsDialog(context)), // Pass the callback
                ],
              ),
            ),

            // Hot Deals Section
            SliverToBoxAdapter(key: _hotDealsKey, child: _buildSectionHeader('⚡ Hot Deals', () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View All Hot Deals')));
            })),
            SliverToBoxAdapter(child: _buildHotDeals(context)),

            // Sale Countdown Timer
            SliverToBoxAdapter(child: _buildSectionHeader('Sale Ends In:', () {})),
            const SliverToBoxAdapter(child: _SaleCountdownTimer()),

            // Sales Section
            SliverToBoxAdapter(key: _salesKey, child: _buildSectionHeader('🏷️ Sales', () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View All Sales Items')));
            })),
            SliverToBoxAdapter(child: _buildSales(context)),

            // New: Need Assistance Section after Sales
            SliverToBoxAdapter(child: _buildNeedAssistanceSection(context)),


            SliverToBoxAdapter(child: _buildFooter(context, colorScheme)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => SortFilterBottomSheet(),
          );
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildAnimatedAppBar(BuildContext context, ColorScheme colorScheme, ProductProvider productProvider) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: colorScheme.background,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: colorScheme.onBackground),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: colorScheme.onBackground.withOpacity(0.7)),
                border: InputBorder.none,
              ),
              style: TextStyle(color: colorScheme.onBackground),
              onChanged: (query) {
                productProvider.searchProducts(query);
              },
            )
          : const Text('SmartShop'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search,
              color: colorScheme.onBackground),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                productProvider.searchProducts('');
                _searchFocusNode.unfocus();
              } else {
                _searchFocusNode.requestFocus();
              }
            });
          },
        ),
        Consumer<CartProvider>(
          builder: (context, cart, child) => Badge(
            label: Text(cart.itemCount.toString()),
            isLabelVisible: cart.itemCount > 0,
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined,
                  color: colorScheme.onBackground),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => CartScreen()));
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text("User"),
            accountEmail: Text(authProvider.userEmail),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => FavoritesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            title: Text(themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode'),
            onTap: () {
                themeProvider.toggleTheme();
                Navigator.of(context).pop();
            }
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.primary,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUMMER COLLECTION',
                    style: TextStyle(
                      color: colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Up to 40% OFF',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_trendingKey.currentContext != null) {
                        Scrollable.ensureVisible(
                          _trendingKey.currentContext!,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          alignment: 0.0,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      foregroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Shop Now'),
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Dynamic Image Carousel for Hero Banner
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final bannerProducts = productProvider.products
                    .where((p) => p.image.isNotEmpty)
                    .take(5)
                    .toList();

                if (productProvider.isLoading) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator(color: colorScheme.onPrimary)),
                  );
                } else if (bannerProducts.isEmpty) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Icon(Icons.broken_image, size: 80, color: colorScheme.onPrimary.withOpacity(0.3)),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: PageView.builder(
                          controller: _bannerPageController,
                          itemCount: bannerProducts.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerPageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final product = bannerProducts[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.grey[600],
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Dot Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerProducts.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentBannerPageIndex == index
                                  ? colorScheme.onPrimary
                                  : colorScheme.onPrimary.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Categories', () {}),
        SizedBox(
          height: 90,
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final categories = productProvider.categories.where((cat) => cat != 'all').toList();
              if (categories.isEmpty) return const SizedBox.shrink();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () {
                        productProvider.setCategory(category);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: productProvider.selectedCategory == category
                                  ? colorScheme.primary
                                  : colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _categoryIcons[category.toLowerCase()] ?? Icons.category,
                              color: productProvider.selectedCategory == category
                                  ? colorScheme.onPrimary
                                  : colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category[0].toUpperCase() + category.substring(1),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingProducts(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final trendingProducts = productProvider.products
        .where((p) => p.rating.rate >= 4.0)
        .take(5)
        .toList();

    if (productProvider.isLoading && trendingProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (productProvider.error.isNotEmpty) {
      return SizedBox(
        height: 280,
        child: Center(child: Text(productProvider.error)),
      );
    }
    if (trendingProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: Text('No trending products found.')),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _trendingPageController,
            scrollDirection: Axis.horizontal,
            padEnds: false,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                _currentTrendingPageIndex = index;
              });
            },
            itemCount: trendingProducts.length,
            itemBuilder: (context, index) {
              final product = trendingProducts[index];
              String? statusLabel;

              if (index == 0) {
                statusLabel = '🔥 Hot!';
              } else if (index == 1) {
                statusLabel = '🆕 New!';
              } else if (product.rating.rate >= 4.5) {
                statusLabel = '✨ Top Rated';
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TrendingCard(
                  product: product,
                  statusLabel: statusLabel,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            trendingProducts.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentTrendingPageIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHotDeals(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final hotDealsProducts = productProvider.products
        .where((p) => p.rating.rate >= 3.9 && p.rating.rate < 4.5 && p.id % 3 == 0)
        .take(5)
        .toList();

    if (productProvider.isLoading && hotDealsProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (productProvider.error.isNotEmpty) {
      return SizedBox(
        height: 280,
        child: Center(child: Text(productProvider.error)),
      );
    }
    if (hotDealsProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: Text('No hot deals found.')),
      );
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: hotDealsProducts.length,
        itemBuilder: (context, index) {
          final product = hotDealsProducts[index];
          String? statusLabel;
          if (product.price < 30) {
             statusLabel = 'Bargain!';
          } else if (product.rating.count > 300) {
            statusLabel = 'Popular!';
          }
          return TrendingCard(
            product: product,
            statusLabel: statusLabel,
          );
        },
      ),
    );
  }

  Widget _buildSales(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final salesProducts = productProvider.products
        .where((p) => p.price < 25 && p.rating.rate > 3.0 && p.id % 2 != 0)
        .take(4)
        .toList();

    if (productProvider.isLoading && salesProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (productProvider.error.isNotEmpty) {
      return SizedBox(
        height: 280,
        child: Center(child: Text(productProvider.error)),
      );
    }
    if (salesProducts.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: Text('No sales items found.')),
      );
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: salesProducts.length,
        itemBuilder: (context, index) {
          final product = salesProducts[index];
          String? statusLabel = 'Sale!';
          return TrendingCard(
            product: product,
            statusLabel: statusLabel,
          );
        },
      ),
    );
  }

  // New Widget for Need Assistance section
  Widget _buildNeedAssistanceSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surfaceVariant, 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.help_outline, size: 50, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Need Assistance?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Our customer support is here to help you with any queries or issues.',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showNeedAssistanceDialog,
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Contact Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, 
                    foregroundColor: colorScheme.onPrimary, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffers(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.secondaryContainer,
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer, size: 50, color: colorScheme.secondary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Autumn Offer! Hurry Up!', // Changed text here
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorScheme.onSecondaryContainer)),
                  Text('Don\'t miss out on amazing deals for the autumn season. Limited time offer!', // Changed text here
                      style: TextStyle(
                          color: colorScheme.onSecondaryContainer.withOpacity(0.8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        // Newsletter Signup Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Updated!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Subscribe to our newsletter for the latest deals and updates.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.8)),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(Icons.email, color: colorScheme.primary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscribed to newsletter!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Subscribe'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24), // Spacing before footer

        // Footer
        Container(
          width: double.infinity,
          color: colorScheme.inverseSurface,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            children: [
              Text('SmartShop',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onInverseSurface)),
              const SizedBox(height: 8),
              Text('© ${DateTime.now().year}. All Rights Reserved. Sylhet, Bangladesh.',
                  style: TextStyle(fontSize: 12, color: colorScheme.onInverseSurface.withOpacity(0.8))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook, color: colorScheme.onInverseSurface),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.wechat, color: colorScheme.onInverseSurface),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.link, color: colorScheme.onInverseSurface),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextButton(onPressed: onViewAll, child: const Text('View All')),
        ],
      ),
    );
  }
}

class _SaleCountdownTimer extends StatefulWidget {
  const _SaleCountdownTimer({super.key});

  @override
  State<_SaleCountdownTimer> createState() => _SaleCountdownTimerState();
}

class _SaleCountdownTimerState extends State<_SaleCountdownTimer> {
  late DateTime _saleEndDate;
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _saleEndDate = DateTime(2025, 7, 25, 23, 59, 59);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _saleEndDate.difference(DateTime.now());
        if (_remainingTime.isNegative) {
          _timer.cancel();
          _remainingTime = Duration.zero;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String days = _remainingTime.inDays.toString().padLeft(2, '0');
    String hours = (_remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Limited Time Offer!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeUnit(days, 'Days', colorScheme),
                _buildTimeUnit(hours, 'Hours', colorScheme),
                _buildTimeUnit(minutes, 'Mins', colorScheme),
                _buildTimeUnit(seconds, 'Secs', colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onTertiary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onTertiaryContainer.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _CustomerDiscountCard extends StatelessWidget {
  const _CustomerDiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.redeem, size: 30, color: colorScheme.onPrimaryContainer),
                  const SizedBox(width: 10),
                  Text(
                    'Exclusive Customer Discount!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Congratulations! You\'ve spent \$500 or more with us.',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Enjoy 15% off your next purchase as our thank you!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Discount code copied! (e.g., DISC15)'))
                    );
                  },
                  icon: Icon(Icons.copy, color: colorScheme.primary),
                  label: Text(
                    'Copy Code',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for membership slider
class _MembershipSlideData {
  final String imagePath;
  final String title;
  final String description;

  _MembershipSlideData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class _MembershipAnnouncementSlider extends StatefulWidget {
  final VoidCallback onLearnMore; // Callback for "Learn More"

  const _MembershipAnnouncementSlider({super.key, required this.onLearnMore});

  @override
  State<_MembershipAnnouncementSlider> createState() => _MembershipAnnouncementSliderState();
}

class _MembershipAnnouncementSliderState extends State<_MembershipAnnouncementSlider> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<_MembershipSlideData> slides = [
    _MembershipSlideData(
      imagePath: 'assets/images/image_1.jpg', 
      title: 'Unlock Lifetime Membership!',
      description: 'Shop for \$500 and receive an exclusive lifetime membership card, granting you access to special perks and discounts!',
    ),
    _MembershipSlideData(
      imagePath: 'assets/images/image_2.jpg', 
      title: 'Exclusive Perks Await!',
      description: 'As a lifetime member, enjoy permanent discounts, early access to sales, and personalized customer support.',
    ),
    _MembershipSlideData(
      imagePath: 'assets/images/image_3.jpg', 
      title: 'Join Our Elite Community!',
      description: 'Become part of our valued members and get invited to exclusive events and product launches.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < slides.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 250, // Adjust height as needed
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: colorScheme.primaryContainer, 
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              slide.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 80, color: colorScheme.onPrimaryContainer.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          slide.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            onPressed: widget.onLearnMore, 
                            icon: Icon(Icons.info_outline, color: colorScheme.primary), 
                            label: Text(
                              'Learn More',
                              style: TextStyle(color: colorScheme.primary), 
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.primary), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: slides.length,
          effect: ExpandingDotsEffect(
            activeDotColor: colorScheme.primary, 
            dotColor: colorScheme.primary.withOpacity(0.4), 
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 2,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}