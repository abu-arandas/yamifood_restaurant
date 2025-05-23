import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/address_controller.dart';
import '../../../models/address_model.dart';
import '../../../controllers/auth_controller.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.find<AddressController>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: controller.streetController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter street address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter state';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.zipCodeController,
              decoration: const InputDecoration(
                labelText: 'ZIP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ZIP code';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final address = AddressModel(
                      id: '',
                      userId: Get.find<AuthController>().currentUser.value!.uid,
                      street: controller.streetController.text,
                      city: controller.cityController.text,
                      state: controller.stateController.text,
                      zipCode: controller.zipCodeController.text,
                      createdAt: DateTime.now(),
                    );
                    await controller.addAddress(address);
                    Get.back(result: true);
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to add address: ${e.toString()}',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
