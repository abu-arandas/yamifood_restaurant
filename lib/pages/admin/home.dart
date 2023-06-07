import '/exports.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaf(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderServices.instance.orders(false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double totalMonthEarning = 0;

            List<OrderModel> monthOrders = snapshot.data!
                .where((element) =>
                    DateTime(element.startTime.year, element.startTime.month) ==
                    DateTime(DateTime.now().year, DateTime.now().month))
                .toList();

            for (OrderModel order in monthOrders) {
              for (var product in order.products) {
                totalMonthEarning = totalMonthEarning + (product.price * product.cartQuantity);
              }
            }

            List<OrderModel> sortedOrders(DateTime month) => snapshot.data!
                .where((element) =>
                    DateTime(element.startTime.year, element.startTime.month) ==
                    DateTime(DateTime.now().year, month.month))
                .toList();

            List<ProductModel> mostSellingProducts = [];

            for (var order in snapshot.data!) {
              for (var product in order.products) {
                if (mostSellingProducts.any((element) => element.id == product.id)) {
                  mostSellingProducts
                      .singleWhere((element) => element.id == product.id)
                      .cartQuantity += product.cartQuantity;
                } else {
                  mostSellingProducts.add(product);
                }
              }
            }

            mostSellingProducts.sort((a, b) => -a.cartQuantity.compareTo(b.cartQuantity));

            return BootstrapContainer(
              children: [
                // Panels
                StreamBuilder<List<ProductModel>>(
                    stream: ProductServices.instance.products(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.hasData) {
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: dPadding),
                            child: BootstrapRow(children: [
                              topSection(
                                color: const Color(0xFF0dcaf0),
                                icon: FontAwesomeIcons.basketShopping,
                                title: 'Monthly Earning',
                                titleData: totalMonthEarning,
                                subTitle: 'Based in your local time (in JD).',
                              ),
                              topSection(
                                color: const Color(0xFF00B517),
                                icon: FontAwesomeIcons.truckFast,
                                title: 'Orders',
                                titleData: double.parse(monthOrders.length.toString()),
                              ),
                              topSection(
                                color: const Color(0xFFfd8a14),
                                icon: FontAwesomeIcons.qrcode,
                                title: 'Products',
                                titleData: productsSnapshot.hasData
                                    ? double.parse(productsSnapshot.data!.length.toString())
                                    : 0,
                              )
                            ]));
                      } else {
                        return waitContainer();
                      }
                    }),

                // Chart
                Container(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    color: transparent.withOpacity(0.25),
                    child: Card(
                        child: SfCartesianChart(
                            margin: EdgeInsets.all(dPadding),
                            title: ChartTitle(
                              text: 'Sale statistics',
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            primaryXAxis: CategoryAxis(),
                            series: <LineSeries<Map<String, dynamic>, String>>[
                          LineSeries<Map<String, dynamic>, String>(
                            dataSource: <Map<String, dynamic>>[
                              {
                                'month': 'Jan',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.january))
                                        .length,
                              },
                              {
                                'month': 'Feb',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.february))
                                        .length,
                              },
                              {
                                'month': 'Mar',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.march))
                                    .length,
                              },
                              {
                                'month': 'Apr',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.april))
                                    .length,
                              },
                              {
                                'month': 'May',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.may))
                                    .length,
                              },
                              {
                                'month': 'Jun',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.june))
                                    .length,
                              },
                              {
                                'month': 'Jul',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.july))
                                    .length,
                              },
                              {
                                'month': 'Aug',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.august))
                                        .length,
                              },
                              {
                                'month': 'Sep',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.september))
                                        .length,
                              },
                              {
                                'month': 'Oct',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.october))
                                        .length,
                              },
                              {
                                'month': 'Nov',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.november))
                                        .length,
                              },
                              {
                                'month': 'Dec',
                                'sales':
                                    sortedOrders(DateTime(DateTime.now().year, DateTime.december))
                                        .length,
                              },
                            ],
                            xValueMapper: (Map<String, dynamic> sales, index) => sales['month'],
                            yValueMapper: (Map<String, dynamic> sales, index) => sales['sales'],
                          )
                        ]))),

                // Most Selling Products
                Padding(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    child: BootstrapRow(children: [
                      BootstrapCol(
                          sizes: 'col-12',
                          child: const BootstrapHeading.h2(text: 'Most Selling Products')),
                      for (var index = 0;
                          index < (mostSellingProducts.length > 3 ? 3 : mostSellingProducts.length);
                          index++)
                        BootstrapCol(
                            sizes: 'col-lg-4 col-md-6 col-sm-12',
                            child: Container(
                                width: double.maxFinite,
                                height: 150,
                                margin: EdgeInsets.all(dPadding),
                                padding: EdgeInsets.all(dPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        MemoryImage(base64Decode(mostSellingProducts[index].image)),
                                    fit: BoxFit.fill,
                                    colorFilter: overlay,
                                  ),
                                  borderRadius: BorderRadius.circular(12.5),
                                  boxShadow: [blackShadow],
                                ),
                                child: BootstrapHeading.h3(
                                  text: mostSellingProducts[index].name,
                                  color: white,
                                  center: true,
                                )))
                    ])),

                // Last Reviews
                Container(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    color: transparent.withOpacity(0.25),
                    child: StreamBuilder<List<ReviewModel>>(
                        stream: reviewsCollection.snapshots().map((query) =>
                            query.docs.map((item) => ReviewModel.fromJson(item)).toList()),
                        builder: (context, reviewsSnapshot) {
                          if (reviewsSnapshot.hasData) {
                            reviewsSnapshot.data!.sort((a, b) => a.date.compareTo(b.date));

                            return BootstrapRow(children: [
                              BootstrapCol(
                                  sizes: 'col-12',
                                  child: const BootstrapHeading.h2(text: 'Customers Reviews')),
                              for (int index = 0;
                                  index <
                                      (reviewsSnapshot.data!.length >= 3
                                          ? 3
                                          : reviewsSnapshot.data!.length);
                                  index++)
                                BootstrapCol(
                                    sizes: 'col-lg-4 col-md-6 col-sm-12',
                                    child: Card(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                          // Name
                                          Padding(
                                              padding: EdgeInsets.all(dPadding / 2),
                                              child: Text(reviewsSnapshot.data![index].name,
                                                  style: TextStyle(
                                                      color: primary,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center)),

                                          // Address
                                          Text(reviewsSnapshot.data![index].address,
                                              textAlign: TextAlign.center),

                                          // Divider
                                          Container(
                                              width: 100,
                                              height: 1,
                                              margin: EdgeInsets.all(dPadding / 2),
                                              color: primary),

                                          // Review
                                          Container(
                                            padding: EdgeInsets.all(dPadding / 2),
                                            child: Text(reviewsSnapshot.data![index].review,
                                                textAlign: TextAlign.center),
                                          )
                                        ])))
                            ]);
                          } else {
                            return waitContainer();
                          }
                        })),

                // Last Orders
                Padding(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    child: Column(children: [
                      const BootstrapHeading.h2(text: 'New Orders'),
                      Column(
                        children: List.generate(snapshot.data!.length,
                            (index) => OrderWidget(order: snapshot.data![index])),
                      )
                    ]))
              ],
            );
          } else {
            return waitContainer();
          }
        },
      ),
    );
  }

  BootstrapCol topSection({
    required Color color,
    required IconData icon,
    required String title,
    required double titleData,
    String? subTitle,
  }) {
    return BootstrapCol(
      sizes: 'col-lg-6 col-md-12 col-sm-12',
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: dPadding, horizontal: dPadding / 2).copyWith(top: 0),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
          tileColor: secondary,
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.25),
            child: Icon(icon, color: color, size: 18),
          ),
          title: RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(text: '\n'),
                WidgetSpan(
                  child: Countup(
                    begin: 0,
                    end: titleData,
                    duration: const Duration(seconds: 3),
                    separator: ',',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          subtitle: subTitle != null
              ? Padding(
                  padding: EdgeInsets.all(dPadding / 2),
                  child: Text(subTitle),
                )
              : Container(),
        ),
      ),
    );
  }
}
