class CartItem {
  int? id;
  String? title;
  String? description;
  int? price;
  String? featured_image;
  int? quantity;

  CartItem(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.featured_image,
      this.quantity});

  CartItem.fromJson(Map<String, dynamic> json) {
    // print("${json['id']} ${json['title']} ${json['price']} ${json['quantity']}");
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    featured_image = json['featured_image'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['featured_image'] = featured_image;
    data['quantity'] = quantity;
    return data;
  }
}
