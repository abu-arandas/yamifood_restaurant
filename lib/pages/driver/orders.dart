import '/exports.dart';

class DriverOrdersPage extends StatefulWidget {
  const DriverOrdersPage({super.key});

  @override
  State<DriverOrdersPage> createState() => _DriverOrdersPageState();
}

class _DriverOrdersPageState extends State<DriverOrdersPage> {
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) => DriverScaf(
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

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(dPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'New Orders',
                            style: title(context: context, color: primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () => showDatePicker(
                            context: context,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 5),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 5),
                            ),
                          ).then((value) {
                            if (value != null) {
                              setState(() => time = value);
                            }
                          }),
                          child: Text(DateFormat.yMMMd().format(time)),
                        ),
                      ],
                    ),
                  ),
                  if (orders.isNotEmpty) ...{
                    FB5Row(
                      children: List.generate(
                        orders.length,
                        (index) => FB5Col(
                          classNames:
                              'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                          child: OrderWidget(order: orders[index]),
                        ),
                      ),
                    ),
                  },
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
                      child: Text('New Orders', style: TextStyle(fontSize: h3)),
                    )
                ],
              );
            } else if (ordersSnapshot.hasError) {
              return Center(child: Text(ordersSnapshot.error.toString()));
            } else if (ordersSnapshot.connectionState ==
                ConnectionState.waiting) {
              return waitContainer();
            } else {
              return Container();
            }
          },
        ),
      );
}
