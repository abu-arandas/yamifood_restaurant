// filepath: c:\Users\user\StudioProjects\yamifood_restaurant\lib\views\driver\profile\driver_profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/driver_controller.dart';

class DriverProfileView extends StatelessWidget {
  final DriverController driverController = Get.find<DriverController>();

  DriverProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
      ),
      body: Obx(
        () {
          if (driverController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = driverController.profile.value;
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          // Extract vehicle info from additional data
          final additionalData = profile.additionalData ?? {};
          final vehicleType = additionalData['vehicleType'] as String? ?? 'Car';
          final licensePlate = additionalData['licensePlate'] as String? ?? '';
          final vehicleColor = additionalData['vehicleColor'] as String? ?? '';

          // Extract settings from additional data
          final pushNotifications = additionalData['pushNotifications'] as bool? ?? true;
          final locationSharing = additionalData['locationSharing'] as bool? ?? true;

          // Get statistics
          final totalDeliveries = driverController.deliveryHistory.length.toString();
          final averageRating = additionalData['averageRating'] as String? ?? '4.5';
          final earnings = additionalData['monthlyEarnings'] as String? ?? '\$0';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profile.profileImage != null ? NetworkImage(profile.profileImage!) : null,
                          child: profile.profileImage == null ? const Icon(Icons.person, size: 50) : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Driver ID: ${profile.id.substring(0, 6).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Personal Information
                _buildSection(
                  title: 'Personal Information',
                  children: [
                    _buildTextField(
                      label: 'Full Name',
                      initialValue: profile.name,
                      onChanged: (value) {
                        driverController.updateProfile(
                          profile.copyWith(name: value, updatedAt: DateTime.now()),
                        );
                      },
                    ),
                    _buildTextField(
                      label: 'Email',
                      initialValue: profile.email,
                      onChanged: (value) {
                        driverController.updateProfile(
                          profile.copyWith(email: value, updatedAt: DateTime.now()),
                        );
                      },
                    ),
                    _buildTextField(
                      label: 'Phone Number',
                      initialValue: profile.phoneNumber ?? '',
                      onChanged: (value) {
                        driverController.updateProfile(
                          profile.copyWith(phoneNumber: value, updatedAt: DateTime.now()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Vehicle Information
                _buildSection(
                  title: 'Vehicle Information',
                  children: [
                    _buildTextField(
                      label: 'Vehicle Type',
                      initialValue: vehicleType,
                      onChanged: (value) {
                        // Update vehicle type in additionalData
                        final updatedData = Map<String, dynamic>.from(profile.additionalData ?? {});
                        updatedData['vehicleType'] = value;

                        driverController.updateProfile(
                          profile.copyWith(
                            additionalData: updatedData,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      },
                    ),
                    _buildTextField(
                      label: 'License Plate',
                      initialValue: licensePlate,
                      onChanged: (value) {
                        // Update license plate in additionalData
                        final updatedData = Map<String, dynamic>.from(profile.additionalData ?? {});
                        updatedData['licensePlate'] = value;

                        driverController.updateProfile(
                          profile.copyWith(
                            additionalData: updatedData,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      },
                    ),
                    _buildTextField(
                      label: 'Vehicle Color',
                      initialValue: vehicleColor,
                      onChanged: (value) {
                        // Update vehicle color in additionalData
                        final updatedData = Map<String, dynamic>.from(profile.additionalData ?? {});
                        updatedData['vehicleColor'] = value;

                        driverController.updateProfile(
                          profile.copyWith(
                            additionalData: updatedData,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Account Settings
                _buildSection(
                  title: 'Account Settings',
                  children: [
                    SwitchListTile(
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive notifications for new orders'),
                      value: pushNotifications,
                      onChanged: (value) {
                        // Update notification settings in additionalData
                        final updatedData = Map<String, dynamic>.from(profile.additionalData ?? {});
                        updatedData['pushNotifications'] = value;

                        driverController.updateProfile(
                          profile.copyWith(
                            additionalData: updatedData,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Location Sharing'),
                      subtitle: const Text('Share your location while on duty'),
                      value: locationSharing,
                      onChanged: (value) {
                        // Update location sharing settings in additionalData
                        final updatedData = Map<String, dynamic>.from(profile.additionalData ?? {});
                        updatedData['locationSharing'] = value;

                        driverController.updateProfile(
                          profile.copyWith(
                            additionalData: updatedData,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Statistics
                _buildSection(
                  title: 'Statistics',
                  children: [
                    _buildStatCard(
                      title: 'Total Deliveries',
                      value: totalDeliveries,
                      icon: Icons.local_shipping,
                    ),
                    _buildStatCard(
                      title: 'Average Rating',
                      value: averageRating,
                      icon: Icons.star,
                    ),
                    _buildStatCard(
                      title: 'Earnings (This Month)',
                      value: earnings,
                      icon: Icons.attach_money,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save all changes together
                      Get.snackbar(
                        'Success',
                        'Profile updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
