// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return DriverScaf(
      pageName: 'Home',
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderServices.instance.driverOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrderModel> orders =
                snapshot.data!.where((element) => element.progress == 'Acepted').toList();

            OrderModel? order = orders.isNotEmpty ? orders.first : null;

            return BootstrapContainer(
              center: false,
              children: [
                // Orders
                BootstrapCol(
                  sizes: 'col-lg-3 col-md-4 col-sm-12',
                  child: Container(
                    height: webScreen(context) ? screenHeight(context) : 75,
                    padding: EdgeInsets.symmetric(vertical: dPadding / 2),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: webScreen(context) ? Axis.vertical : Axis.horizontal,
                      itemCount: orders.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: dPadding),
                        child: ElevatedButton(
                          onPressed: () => setState(() => order = orders[index]),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
                            ),
                            padding: MaterialStatePropertyAll(EdgeInsets.all(dPadding)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.dragged) ||
                                      states.contains(MaterialState.pressed) ||
                                      order == orders[index]
                                  ? primary
                                  : white,
                            ),
                            foregroundColor: MaterialStateProperty.resolveWith(
                              (states) => states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.dragged) ||
                                      states.contains(MaterialState.pressed) ||
                                      order == orders[index]
                                  ? white
                                  : primary,
                            ),
                          ),
                          child: Text(orders[index].id),
                        ),
                      ),
                    ),
                  ),
                ),

                // Order Map
                BootstrapCol(
                  sizes: 'col-lg-9 col-md-8 col-sm-12',
                  child: order != null
                      ? OrderWidget(order: order!)
                      : Container(
                          height: screenHeight(context) * 0.5,
                          margin: EdgeInsets.all(dPadding),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(dPadding),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [blackShadow],
                          ),
                          child: const BootstrapHeading.h3(text: 'No New Orders'),
                        ),
                ),
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
