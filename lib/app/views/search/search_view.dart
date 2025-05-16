import '../../../exports.dart';

class SearchView extends GetView<FoodController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final RxString searchQuery = ''.obs;
    final RxBool isSearching = false.obs;
    final RxList<FoodModel> searchResults = <FoodModel>[].obs;

    // Function to handle search
    void performSearch(String query) {
      if (query.isEmpty) {
        searchResults.clear();
        isSearching.value = false;
        return;
      }

      isSearching.value = true;

      // Simulate a slight delay for a more natural feel
      Future.delayed(const Duration(milliseconds: 300), () {
        final results = controller.allFoods.where((food) {
          return food.name.toLowerCase().contains(query.toLowerCase()) ||
              food.description.toLowerCase().contains(query.toLowerCase()) ||
              food.category.toLowerCase().contains(query.toLowerCase());
        }).toList();

        searchResults.value = results;
        isSearching.value = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for foods, categories...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      searchQuery.value = '';
                      performSearch('');
                    },
                  )
                : const SizedBox.shrink()),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            searchQuery.value = value;
            performSearch(value);
          },
        ),
      ),
      body: Obx(() {
        if (isSearching.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (searchQuery.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Search for your favorite foods',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found for "${searchQuery.value}"',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.find<HomeController>().changeTab(1); // Go to Menu tab
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Browse Menu'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final food = searchResults[index];
            return AnimatedFoodCard(
              food: food,
              onTap: () => Get.toNamed(
                Routes.FOOD_DETAILS,
                arguments: food,
              ),
              isFavorite: Get.find<HomeController>().isFoodFavorite(food),
              onToggleFavorite: () => Get.find<HomeController>().toggleFavorite(food),
            );
          },
        );
      }),
    );
  }
}
