class RecipeIngredient {
  final String name;
  final int quantity;

  RecipeIngredient(this.name, this.quantity);

  RecipeIngredient.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        quantity = json['quantity'] as int;

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}