
class Product {
  int? id;
  String? title;
  String? description;
  int? price;
  String? featured_image;
  String? status;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.featured_image,
      this.status});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    featured_image = json['featured_image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data ={};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['featured_image'] = featured_image;
    data['status'] = status;
    return data;
  }
}