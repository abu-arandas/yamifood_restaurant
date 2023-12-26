import 'dart:math';

import '/exports.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) => AdminScaf(
        body: StreamBuilder<List<OrderModel>>(
          stream: OrderServices.instance.orders(false),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double totalMonthEarning = 0;

              List<OrderModel> monthOrders = snapshot.data!
                  .where(
                      (element) => DateTime(element.startTime.year, element.startTime.month) == DateTime(DateTime.now().year, DateTime.now().month))
                  .toList();

              for (OrderModel order in monthOrders) {
                for (var product in order.products) {
                  totalMonthEarning = totalMonthEarning + (product.price * product.cartQuantity);
                }
              }

              List<OrderModel> sortedOrders(DateTime month) => snapshot.data!
                  .where((element) => DateTime(element.startTime.year, element.startTime.month) == DateTime(DateTime.now().year, month.month))
                  .toList();

              List<ProductModel> mostSellingProducts = [];

              for (var order in snapshot.data!) {
                for (var product in order.products) {
                  if (mostSellingProducts.any((element) => element.id == product.id)) {
                    mostSellingProducts.singleWhere((element) => element.id == product.id).cartQuantity += product.cartQuantity;
                  } else {
                    mostSellingProducts.add(product);
                  }
                }
              }

              mostSellingProducts.sort((a, b) => -a.cartQuantity.compareTo(b.cartQuantity));

              return Wrap(
                children: [
                  // Panels
                  StreamBuilder<List<ProductModel>>(
                    stream: ProductServices.instance.products(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: dPadding),
                          child: Wrap(
                            children: [
                              topSection(
                                color: const Color(0xFF0dcaf0),
                                icon: Icons.shopping_bag,
                                title: 'Monthly Earning',
                                titleData: totalMonthEarning,
                                subTitle: 'Based in your local time (in JD).',
                              ),
                              topSection(
                                color: const Color(0xFF00B517),
                                icon: FontAwesomeIcons.truckFast,
                                title: 'Orders',
                                titleData: monthOrders.length,
                              ),
                              topSection(
                                color: const Color(0xFFfd8a14),
                                icon: Icons.qr_code,
                                title: 'Products',
                                titleData: productsSnapshot.data!.length,
                              ),
                            ],
                          ),
                        );
                      } else if (productsSnapshot.hasError) {
                        return Center(child: Text(productsSnapshot.error.toString()));
                      } else if (productsSnapshot.connectionState == ConnectionState.waiting) {
                        return waitContainer();
                      } else {
                        return Container();
                      }
                    },
                  ),

                  // Chart
                  Container(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    color: transparent.withOpacity(0.25),
                    child: Card(
                      child: SfCartesianChart(
                        margin: EdgeInsets.all(dPadding),
                        title: const ChartTitle(
                          text: 'Sale statistics',
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        primaryXAxis: const CategoryAxis(),
                        series: <LineSeries<Map<String, dynamic>, String>>[
                          LineSeries<Map<String, dynamic>, String>(
                            dataSource: <Map<String, dynamic>>[
                              {
                                'month': 'Jan',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.january)).length,
                              },
                              {
                                'month': 'Feb',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.february)).length,
                              },
                              {
                                'month': 'Mar',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.march)).length,
                              },
                              {
                                'month': 'Apr',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.april)).length,
                              },
                              {
                                'month': 'May',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.may)).length,
                              },
                              {
                                'month': 'Jun',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.june)).length,
                              },
                              {
                                'month': 'Jul',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.july)).length,
                              },
                              {
                                'month': 'Aug',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.august)).length,
                              },
                              {
                                'month': 'Sep',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.september)).length,
                              },
                              {
                                'month': 'Oct',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.october)).length,
                              },
                              {
                                'month': 'Nov',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.november)).length,
                              },
                              {
                                'month': 'Dec',
                                'sales': sortedOrders(DateTime(DateTime.now().year, DateTime.december)).length,
                              },
                            ],
                            xValueMapper: (Map<String, dynamic> sales, index) => sales['month'],
                            yValueMapper: (Map<String, dynamic> sales, index) => sales['sales'],
                          )
                        ],
                      ),
                    ),
                  ),

                  // Most Selling Products
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    child: SizedBox(
                      width: maxWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(dPadding),
                            child: Text('Most Selling Products', style: title(context: context, color: primary)),
                          ),
                          Wrap(
                            children: List.generate(
                              min(mostSellingProducts.length, 3),
                              (index) => Div(
                                lg: Col.col4,
                                md: Col.col6,
                                sm: Col.col12,
                                child: Container(
                                  width: double.maxFinite,
                                  height: 150,
                                  margin: EdgeInsets.all(dPadding),
                                  padding: EdgeInsets.all(dPadding),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(base64Decode(mostSellingProducts[index].image)),
                                      fit: BoxFit.fill,
                                      colorFilter: overlay,
                                    ),
                                    borderRadius: BorderRadius.circular(12.5),
                                    boxShadow: [blackShadow],
                                  ),
                                  child: Text(
                                    mostSellingProducts[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: h2,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Last Reviews
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    color: transparent.withOpacity(0.25),
                    child: StreamBuilder<List<ReviewModel>>(
                      stream: reviewsCollection.snapshots().map((query) => query.docs.map((item) => ReviewModel.fromJson(item)).toList()),
                      builder: (context, reviewsSnapshot) {
                        if (reviewsSnapshot.hasData) {
                          reviewsSnapshot.data!.sort((a, b) => a.date.compareTo(b.date));

                          return SizedBox(
                            width: maxWidth(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(dPadding),
                                  child: Text('Customers Reviews', style: title(context: context, color: primary)),
                                ),
                                Wrap(
                                  children: List.generate(
                                    reviewsSnapshot.data!.length,
                                    (index) => Div(
                                      lg: Col.col4,
                                      md: Col.col6,
                                      sm: Col.col12,
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
                                                    style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center)),

                                            // Divider
                                            Container(width: 100, height: 1, margin: EdgeInsets.all(dPadding / 2), color: primary),

                                            // Review
                                            Container(
                                              padding: EdgeInsets.all(dPadding / 2),
                                              child: Text(reviewsSnapshot.data![index].review, textAlign: TextAlign.center),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return waitContainer();
                        }
                      },
                    ),
                  ),

                  // Last Orders
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: dPadding),
                    child: Column(
                      children: [
                        Text('New Orders', style: title(context: context, color: primary)),
                        Wrap(
                          children: List.generate(
                            snapshot.data!.length,
                            (index) => Div(
                              lg: Col.col4,
                              md: Col.col6,
                              sm: Col.col12,
                              padding: EdgeInsets.all(dPadding / 2),
                              child: OrderWidget(order: snapshot.data![index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return waitContainer();
            } else {
              return Container();
            }
          },
        ),
      );

  Widget topSection({
    required Color color,
    required IconData icon,
    required String title,
    required num titleData,
    String? subTitle,
  }) =>
      Div(
        lg: Col.col6,
        md: Col.col12,
        sm: Col.col12,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dPadding, horizontal: dPadding / 2).copyWith(top: 0),
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
                  TextSpan(text: titleData.toString()),
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
