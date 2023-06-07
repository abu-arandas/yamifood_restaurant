// ignore_for_file: prefer_collection_literals, depend_on_referenced_packages

import '/exports.dart';
import 'package:intl/intl.dart';

class DriverOrdersPage extends StatefulWidget {
  const DriverOrdersPage({super.key});

  @override
  State<DriverOrdersPage> createState() => _DriverOrdersPageState();
}

class _DriverOrdersPageState extends State<DriverOrdersPage> {
  DateTime time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return DriverScaf(
      pageName: 'History',
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderServices.instance.driverOrders(),
        builder: (context, ordersSnapshot) {
          if (ordersSnapshot.hasData) {
            List<OrderModel> orders = ordersSnapshot.data!
                .where((element) =>
                    element.startTime.year == time.year &&
                    element.startTime.month == time.month &&
                    element.startTime.day == time.day)
                .toList();

            return BootstrapContainer(
              children: [
                Padding(
                  padding: EdgeInsets.all(dPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const BootstrapHeading.h2(text: 'New Orders'),
                      TextButton(
                        onPressed: () => showDialog(
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return BootstrapModal(
                              title: 'Select Orders Day',
                              content: SfDateRangePicker(
                                view: DateRangePickerView.month,
                                selectionMode: DateRangePickerSelectionMode.single,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                  if (args.value is DateTime) {
                                    setState(() => time = args.value);
                                  }
                                  Get.back();
                                },
                              ),
                            );
                          },
                        ),
                        child: BootstrapHeading.h5(text: DateFormat.yMMMd().format(time)),
                      ),
                    ],
                  ),
                ),
                Column(
                  children:
                      List.generate(orders.length, (index) => OrderWidget(order: orders[index])),
                ),
                if (orders.isEmpty)
                  Container(
                    height: screenHeight(context) * 0.5,
                    margin: EdgeInsets.all(dPadding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [blackShadow],
                    ),
                    child: const BootstrapHeading.h3(text: 'New Orders'),
                  )
              ],
            );
          } else {
            return waitContainer();
          }
        },
      ),
    );
  }
}
