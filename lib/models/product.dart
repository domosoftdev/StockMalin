class Product {
  final String id;
  final String name;
  final String location;
  final int quantity;
  final int total;
  final String image;
  final String note;

  Product({
    required this.id,
    required this.name,
    required this.location,
    required this.quantity,
    required this.total,
    required this.image,
    required this.note,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        name: j['name'] as String,
        location: j['location'] as String? ?? '',
        quantity: (j['quantity'] as num).toInt(),
        total: (j['total'] as num).toInt(),
        image: j['image'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'quantity': quantity,
        'total': total,
        'image': image,
        'note': note,
      };
}
