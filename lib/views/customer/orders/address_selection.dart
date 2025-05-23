import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/address_model.dart';
import '../../../controllers/address_controller.dart';
import 'add_address_view.dart';

class AddressSelection extends StatelessWidget {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final Function(AddressModel) onAddressSelected;

  const AddressSelection({
    Key? key,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (addresses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No addresses found. Please add a delivery address.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...addresses.map((address) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RadioListTile<AddressModel>(
                  value: address,
                  groupValue: selectedAddress,
                  onChanged: (value) {
                    if (value != null) {
                      onAddressSelected(value);
                    }
                  },
                  title: Text(
                    address.street,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${address.city}, ${address.state} ${address.zipCode}'),
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      Get.find<AddressController>().deleteAddress(address.id);
                    },
                  ),
                ),
              )),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Get.to(() => const AddAddressView());
                if (result == true) {
                  Get.find<AddressController>().loadAddresses();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
