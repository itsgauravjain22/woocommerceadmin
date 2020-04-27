import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:woocommerceadmin/src/orders/providers/orders_list_filters_provider.dart';

class OrdersListFiltersModal extends StatefulWidget {
  final String baseurl;
  final String username;
  final String password;
  final Function handleRefresh;

  OrdersListFiltersModal({
    Key key,
    @required this.baseurl,
    @required this.username,
    @required this.password,
    @required this.handleRefresh,
  }) : super(key: key);

  @override
  _OrdersListFiltersModalState createState() => _OrdersListFiltersModalState();
}

class _OrdersListFiltersModalState extends State<OrdersListFiltersModal> {
  bool _isInit = true;
  String sortOrderByValue = "date";
  String sortOrderValue = "desc";

  bool isOrderStatusOptionsReady = true;
  bool isOrderStatusOptionsError = false;
  String orderStatusOptionsError;
  Map<String, bool> orderStatusOptions = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      OrdersListFiltersProvider ordersListFiltersProvider =
          Provider.of<OrdersListFiltersProvider>(context, listen: false);
      sortOrderByValue = ordersListFiltersProvider.sortOrderByValue;
      sortOrderValue = ordersListFiltersProvider.sortOrderValue;
      orderStatusOptions = ordersListFiltersProvider.orderStatusOptions;
      if (orderStatusOptions.isEmpty) {
        fetchOrderStatusOptions();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sort & Filter"),
      titlePadding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      content: Container(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Sort by",
                style: Theme.of(context).textTheme.subhead,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: DropdownButton<String>(
                          underline: SizedBox.shrink(),
                          value: sortOrderByValue,
                          onChanged: (String newValue) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              sortOrderByValue = newValue;
                            });
                          },
                          items: <String>[
                            "date",
                            "id",
                            "title",
                            "slug",
                            "include"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.titleCase,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.body1,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.arrow_downward,
                          color: (sortOrderValue == "desc")
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          sortOrderValue = "desc";
                        });
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.arrow_upward,
                          color: (sortOrderValue == "asc")
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          sortOrderValue = "asc";
                        });
                      },
                    ),
                  ],
                ),
              ),
              Text(
                "Filter by",
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Order Status",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isOrderStatusOptionsError
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              orderStatusOptionsError,
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ),
                      ],
                    )
                  : (orderStatusOptions.isNotEmpty && isOrderStatusOptionsReady)
                      ? Column(
                          children: orderStatusOptions.keys.map((String key) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  orderStatusOptions[key] =
                                      !orderStatusOptions[key];
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: orderStatusOptions[key],
                                      onChanged: (bool value) {
                                        setState(() {
                                          orderStatusOptions[key] = value;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        key.titleCase,
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Center(
                            child: SpinKitPulse(
                              color: Theme.of(context).primaryColor,
                              size: 50,
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Apply"),
          onPressed: () {
            Provider.of<OrdersListFiltersProvider>(context, listen: false)
                .changeFilterModalValues(
                    sortOrderByValue: sortOrderByValue,
                    sortOrderValue: sortOrderValue,
                    orderStatusOptions: orderStatusOptions);
            widget.handleRefresh();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Future<void> fetchOrderStatusOptions() async {
    String url =
        "${widget.baseurl}/wp-json/wc/v3/reports/orders/totals?consumer_key=${widget.username}&consumer_secret=${widget.password}";
    setState(() {
      isOrderStatusOptionsReady = false;
      isOrderStatusOptionsError = false;
    });
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        if (json.decode(response.body) is List &&
            !json.decode(response.body).isEmpty) {
          Map<String, bool> tempMap = orderStatusOptions;
          json.decode(response.body).forEach((item) {
            if (item is Map &&
                item.containsKey("slug") &&
                item["slug"] is String &&
                item["slug"].isNotEmpty) {
              tempMap.putIfAbsent(item["slug"], () => false);
            }
          });
          setState(() {
            isOrderStatusOptionsReady = true;
            orderStatusOptions = tempMap;
          });
        } else {
          setState(() {
            isOrderStatusOptionsReady = false;
            isOrderStatusOptionsError = true;
            orderStatusOptionsError = "Failed to fetch order status options";
          });
        }
      } else {
        String errorCode = "";
        if (json.decode(response.body) is Map &&
            json.decode(response.body).containsKey("code") &&
            json.decode(response.body)["code"] is String) {
          errorCode = json.decode(response.body)["code"];
        }
        setState(() {
          isOrderStatusOptionsReady = false;
          isOrderStatusOptionsError = true;
          orderStatusOptionsError =
              "Failed to fetch order status options. Error: $errorCode";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isOrderStatusOptionsReady = false;
        isOrderStatusOptionsError = true;
        orderStatusOptionsError =
            "Failed to fetch order status options. Error: Network not reachable";
      });
    } catch (e) {
      setState(() {
        isOrderStatusOptionsReady = false;
        isOrderStatusOptionsError = true;
        orderStatusOptionsError =
            "Failed to fetch order status options. Error: $e";
      });
    }
  }
}
