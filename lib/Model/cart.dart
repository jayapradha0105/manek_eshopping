class Cart {
  int? id;
  int? quantity;

  Cart(
      {this.id,
      this.quantity});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data ={};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}