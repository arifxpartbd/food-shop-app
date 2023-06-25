
class CartItem{
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
   required this.id,
    required this.price,
    required this.name,
    required this.quantity
});

  factory CartItem.fromMap(Map<String, dynamic> map){
    return CartItem(
        id: map['id'],
        price: map['price'],
        name: map['name'],
        quantity: map['quantity'],
    );
  }

}