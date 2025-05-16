import '../../../exports.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    // Text controllers for editing profile
    final nameController = TextEditingController(
      text: controller.user?.name ?? '',
    );
    final phoneController = TextEditingController(
      text: controller.user?.phoneNumber ?? '',
    );
    final addressController = TextEditingController(
      text: controller.user?.address ?? '',
    );

    final isEditing = false.obs;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          Obx(() => isEditing.value
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    isEditing.value = false;
                    nameController.text = controller.user?.name ?? '';
                    phoneController.text = controller.user?.phoneNumber ?? '';
                    addressController.text = controller.user?.address ?? '';
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    isEditing.value = true;
                  },
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You need to login to view your profile',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        controller.user!.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.user!.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.user!.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Profile Details
              Obx(() => isEditing.value
                  ? Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.updateUserProfile(
                                    name: nameController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                    address: addressController.text.trim(),
                                  );
                                  isEditing.value = false;
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text('SAVE CHANGES'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Full Name'),
                          subtitle: Text(controller.user!.name),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text(controller.user!.email),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Phone Number'),
                          subtitle: Text(
                            controller.user!.phoneNumber ?? 'Not provided',
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('Address'),
                          subtitle: Text(
                            controller.user!.address ?? 'Not provided',
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.receipt_long),
                          title: const Text('Orders'),
                          subtitle: const Text('View your order history'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => Get.toNamed(Routes.ORDERS),
                        ),
                      ],
                    )),
              const SizedBox(height: 32),

              // Orders Section
              const Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (orderController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (orderController.userOrders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No orders yet'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderController.userOrders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.userOrders[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id.substring(0, 8)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Helpers.getOrderStatusColor(order.status),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    order.status.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date: ${Helpers.formatDateTime(order.createdAt)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${order.items.length} items for ${Helpers.formatCurrency(order.total)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Delivery to: ${order.deliveryAddress}',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (order.status == OrderStatus.pending)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => orderController.cancelOrder(order.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('CANCEL ORDER'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('LOGOUT'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
