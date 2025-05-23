import 'package:flutter/material.dart';

class AdminSettingsView extends StatelessWidget {

  const AdminSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRestaurantSettings(),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildAppearanceSettings(context),
            const SizedBox(height: 24),
            _buildPaymentSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Restaurant Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(),
              ),
              initialValue: 'YamiFood Restaurant',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Restaurant Address',
                border: OutlineInputBorder(),
              ),
              initialValue: '123 Food Street, Cuisine City',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: '+1 (555) 123-4567',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: 'contact@yamifood.com',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHours(),
          ],
        ),
      ),
    );
  }

  Widget _buildHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operating Hours',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildTimeRow('Monday - Friday', '9:00 AM', '10:00 PM'),
        _buildTimeRow('Saturday', '10:00 AM', '11:00 PM'),
        _buildTimeRow('Sunday', '10:00 AM', '9:00 PM'),
      ],
    );
  }

  Widget _buildTimeRow(String day, String openTime, String closeTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(day),
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Open',
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
              ),
              initialValue: openTime,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Close',
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
              ),
              initialValue: closeTime,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Order Notifications'),
              subtitle: const Text('Receive notifications for new orders'),
              value: true,
              onChanged: (value) {
                // Update notification settings
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Review Notifications'),
              subtitle: const Text('Receive notifications for new customer reviews'),
              value: true,
              onChanged: (value) {
                // Update notification settings
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Low Inventory Alerts'),
              subtitle: const Text('Get alerts when inventory items are running low'),
              value: true,
              onChanged: (value) {
                // Update notification settings
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive notifications via email'),
              value: false,
              onChanged: (value) {
                // Update notification settings
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Theme'),
                DropdownButton<String>(
                  value: 'System',
                  items: ['Light', 'Dark', 'System']
                      .map((mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // Update theme
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Primary Color'),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Font Size'),
                DropdownButton<String>(
                  value: 'Medium',
                  items: ['Small', 'Medium', 'Large']
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // Update font size
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Accept Cash'),
              value: true,
              onChanged: (value) {
                // Update payment settings
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Accept Credit Cards'),
              value: true,
              onChanged: (value) {
                // Update payment settings
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Accept Online Payments'),
              value: true,
              onChanged: (value) {
                // Update payment settings
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Connected Payment Accounts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Stripe'),
              subtitle: const Text('Connected'),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Open payment settings
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('PayPal'),
              subtitle: const Text('Not connected'),
              trailing: TextButton(
                child: const Text('Connect'),
                onPressed: () {
                  // Connect PayPal
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
