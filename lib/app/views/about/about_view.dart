import '../../../exports.dart';

class AboutView extends GetView<HomeController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Image
            Image.asset(
              'asset/images/about.png',
              fit: BoxFit.cover,
              height: 200,
            ),

            // Company Introduction
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yamifood Restaurant',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to Yamifood Restaurant, where culinary excellence meets exceptional service.',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Founded in 2020, Yamifood Restaurant has grown from a small family-owned establishment to a beloved dining destination. Our mission is simple: to provide delicious food, excellent service, and a warm atmosphere for our customers.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Our Story Section
                  const Text(
                    'Our Story',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Yamifood Restaurant was born from a passion for authentic cuisine and quality ingredients. Our founder, Chef Alex Rodriguez, traveled extensively throughout various culinary capitals, gathering inspiration and perfecting recipes before opening our doors.\n\nWhat started as a dream has now become a successful restaurant chain, serving thousands of satisfied customers daily through both dine-in and our modern delivery service.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Our Chefs Section
                  const Text(
                    'Our Chefs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chef Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildChefCard(
                          name: 'Alex Rodriguez',
                          position: 'Executive Chef',
                          iconData: Icons.person,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChefCard(
                          name: 'Maria Chen',
                          position: 'Pastry Chef',
                          iconData: Icons.person,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChefCard(
                          name: 'John Smith',
                          position: 'Sous Chef',
                          iconData: Icons.person,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChefCard(
                          name: 'Sarah Johnson',
                          position: 'Head Chef',
                          iconData: Icons.person,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Our Philosophy
                  const Text(
                    'Our Philosophy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'At Yamifood Restaurant, we believe that great food starts with great ingredients. We source locally whenever possible, supporting our community farmers and ensuring the freshest products for our dishes.\n\nWe are committed to sustainability and eco-friendly practices in all aspects of our operation. From biodegradable packaging to energy-efficient appliances, we strive to minimize our environmental footprint.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Info
                  const Text(
                    'Visit Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                    title: const Text('123 Culinary Street, Foodie City, FC 12345'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
                    title: const Text('+1 (555) 123-4567'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: AppTheme.primaryColor),
                    title: const Text('info@yamifood.com'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // Hours
                  const Text(
                    'Opening Hours',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arbutus Slab',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildHoursRow('Monday - Friday', '8:00 AM - 10:00 PM'),
                  _buildHoursRow('Saturday', '9:00 AM - 11:00 PM'),
                  _buildHoursRow('Sunday', '10:00 AM - 9:00 PM'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChefCard({
    required String name,
    required String position,
    required IconData iconData,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(
                iconData,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              position,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursRow(String days, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            days,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
