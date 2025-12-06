class Buffalo {
  final String id;
  final String breed;
  final int? age;
  final int milkYield;
  final int price;
  final bool inStock;
  final int insurance;
  final List<String> buffaloImages;
  final String description;

  Buffalo({
    required this.id,
    required this.breed,
    required this.age,
    required this.milkYield,
    required this.price,
    required this.inStock,
    required this.insurance,
    required this.buffaloImages,
    required this.description,
  });

  // Factory constructor for JSON => Model
  factory Buffalo.fromJson(Map<String, dynamic> json) {
    return Buffalo(
      id: json['id'],
      breed: json['breed'],
      age: json['age'],
      milkYield: json['milkYield'],
      price: json['price'],
      inStock: json['inStock'],
      insurance: json['insurance'],
      buffaloImages: List<String>.from(json['buffalo_images']),
      description: json['description'],
    );
  }

  // Convert Model => JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "breed": breed,
      "age": age,
      "milkYield": milkYield,
      "price": price,
      "inStock": inStock,
      "insurance": insurance,
      "buffalo_images": buffaloImages,
      "description": description,
    };
  }
}
