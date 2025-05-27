import 'package:imat_app/model/imat/shopping_item.dart';

class Order {
  int orderNumber;
  DateTime date;
  List<ShoppingItem> items;

  Order(this.orderNumber, this.date, this.items);

  factory Order.fromJson(Map<String, dynamic> json) {
    int orderNumber = json[_orderNumber] as int;
    int timeStamp = json[_date] as int;
    List jsonItems = json[_items];

    List<ShoppingItem> items = [];
    for (final jsonItem in jsonItems) {
      items.add(ShoppingItem.fromJson(jsonItem));
    }

    return Order(
      orderNumber,
      DateTime.fromMillisecondsSinceEpoch(timeStamp),
      items,
    );
  }

  Map<String, dynamic> toJson() => {
    _orderNumber: orderNumber,
    _date: date.millisecondsSinceEpoch,
    _items: items.map((item) => item.toJson()).toList(),
  };

  double getTotal() {
    return items.fold(
      0.0,
      (sum, item) => sum + item.product.price * item.amount,
    );
  }

  static const _orderNumber = 'orderNumber';
  static const _date = 'date';
  static const _items = 'items';
}
