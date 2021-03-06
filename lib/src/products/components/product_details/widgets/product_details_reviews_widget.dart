import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerceadmin/src/products/components/edit_product/screens/edit_product_reviews_screen.dart';
import 'package:woocommerceadmin/src/products/components/product_details/helpers/product_details_widget_helpers.dart';
import 'package:woocommerceadmin/src/products/models/product.dart';
import 'package:woocommerceadmin/src/products/providers/product_provider.dart';

class ProductDetailsReviewsWidget extends StatelessWidget {
  final String baseurl;
  final String username;
  final String password;

  ProductDetailsReviewsWidget({
    @required this.baseurl,
    @required this.username,
    @required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final Product productData = productProvider.product;
    Widget productReviewsWidget = SizedBox.shrink();
    List<Widget> productReviewsWidgetData = [];

    if (productData?.reviewsAllowed is bool) {
      productReviewsWidgetData.add(
        ProductDetailsWidgetsHelper.getItemRow(
          context: context,
          item1: "Reviews allowed: ",
          item2: productData.reviewsAllowed ? "Yes" : "No",
        ),
      );
    }

    if (productData?.averageRating is String &&
        productData.averageRating is String) {
      productReviewsWidgetData.add(
        ProductDetailsWidgetsHelper.getItemRow(
          context: context,
          item1: "Average rating: ",
          item2: productData.averageRating,
        ),
      );
    }

    if (productData?.ratingCount is int) {
      productReviewsWidgetData.add(
        ProductDetailsWidgetsHelper.getItemRow(
          context: context,
          item1: "Rating count: ",
          item2: "${productData.ratingCount}",
        ),
      );
    }

    if (productReviewsWidgetData.isNotEmpty) {
      productReviewsWidget = ProductDetailsWidgetsHelper.getExpansionTile(
        context: context,
        title: "Reviews",
        widgetsList: productReviewsWidgetData,
        isTappable: true,
        onTap: () async {
          String result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: productProvider,
                child: EditProductReviewsScreen(
                  baseurl: this.baseurl,
                  username: this.username,
                  password: this.password,
                ),
              ),
            ),
          );
          if (result is String) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(result.toString()),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      );
    }
    return productReviewsWidget;
  }
}
