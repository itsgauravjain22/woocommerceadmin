import 'package:flutter/foundation.dart';
import 'package:woocommerceadmin/src/common/widgets/multi_select.dart';

class OrdersListFiltersProvider with ChangeNotifier {
  bool _isSearching = false;
  String _searchValue = "";

  String _sortOrderByValue = "date";
  String _sortOrderValue = "desc";
  List<MultiSelectMenu> _orderStatusOptions = [];
  List _selectedOrderStatus = [];

  bool get isSearching => _isSearching;
  String get searchValue => _searchValue;

  String get sortOrderByValue => _sortOrderByValue;
  String get sortOrderValue => _sortOrderValue;
  List<MultiSelectMenu> get orderStatusOptions => _orderStatusOptions;
  List get selectedOrderStatus => _selectedOrderStatus;

  void toggleIsSearching() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void changeSearchValue(String searchValue) {
    _searchValue = searchValue;
    notifyListeners();
  }

  void changeOrderStatusOptions(List<MultiSelectMenu> orderStatusOptions){
    _orderStatusOptions = orderStatusOptions;
  }

  void changeFilterModalValues({
    @required String sortOrderByValue,
    @required String sortOrderValue,
    @required List selectedOrderStatus,
  }) {
    _sortOrderByValue = sortOrderByValue;
    _sortOrderValue = sortOrderValue;
    _selectedOrderStatus = selectedOrderStatus;
    notifyListeners();
  }
}
