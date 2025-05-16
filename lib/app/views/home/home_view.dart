import '../../../exports.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final foodController = Get.find<FoodController>();
    final cartController = Get.put(CartController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'asset/images/logo.png',
          height: 50,
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartController.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${cartController.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Get.toNamed(Routes.CART),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed(Routes.SEARCH),
          ),
          Obx(() => authController.isLoggedIn
              ? IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => Get.toNamed(Routes.PROFILE),
                )
              : IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                )),
        ],
      ),
      drawer: _buildDrawer(context, authController),
      body: Column(
        children: [
          // Banner
          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.changePage,
              children: [
                Image.asset(
                  'asset/images/slider-01.jpg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'asset/images/slider-02.jpg',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'asset/images/slider-03.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),

          // Page Indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.currentIndex.value == index ? AppTheme.primaryColor : Colors.grey,
                            ),
                          )),
                )),
          ),

          // Category Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: AppTheme.titleStyle,
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final categories = ['All', ...foodController.categories.map((c) => c.name)];
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Obx(() => GestureDetector(
                              onTap: () => foodController.changeCategory(category),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: foodController.selectedCategory.value == category
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: foodController.selectedCategory.value == category
                                        ? Colors.white
                                        : AppTheme.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Food List
          Expanded(
            child: Obx(() {
              final foods = foodController.selectedCategory.value == 'All'
                  ? foodController.allFoods
                  : foodController.getFoodsByCategory(foodController.selectedCategory.value);

              if (foodController.isLoading.value) {
                return Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, __) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (foods.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items available in this category',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final refreshController = RefreshController();

              return SmartRefresher(
                controller: refreshController,
                enablePullDown: true,
                header: const WaterDropHeader(),
                onRefresh: () {
                  foodController.fetchAllFoods().then((_) {
                    refreshController.refreshCompleted();
                  }).catchError((_) {
                    refreshController.refreshFailed();
                  });
                },
                child: AnimationLimiter(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: GestureDetector(
                            onTap: () {
                              foodController.setSelectedFood(food);
                              Get.toNamed(Routes.FOOD_DETAILS);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Food Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: SizedBox(
                                      height: 120,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: food.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(color: Colors.grey[300]),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Colors.grey.shade300,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.image, size: 50),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Food Info
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          food.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          food.description,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Helpers.formatCurrency(food.price),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: AppTheme.primaryColor,
                                              ),
                                              onPressed: () {
                                                cartController.addToCart(food, 1);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthController authController) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'asset/images/logo.png',
                  height: 80,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Yamifood Restaurant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arbutus Slab',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back();
              Get.offNamed(Routes.HOME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menu'),
            onTap: () {
              Get.back();
              controller.changeTab(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.CART);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Get.back();
              controller.changeTab(3);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.ABOUT);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Us'),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.CONTACT);
            },
          ),
          Obx(() => authController.isLoggedIn
              ? ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('My Orders'),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.ORDERS);
                  },
                )
              : const SizedBox.shrink()),
          const Divider(),
          ListTile(
            leading: Get.isDarkMode ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
            title: const Text('Theme'),
            trailing: const ThemeToggle(),
            onTap: () {
              Get.find<ThemeService>().switchTheme();
            },
          ),
          const Divider(),
          Obx(() => authController.isLoggedIn
              ? ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Get.back();
                    authController.signOut();
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.LOGIN);
                  },
                )),
        ],
      ),
    );
  }
}
