import 'package:pokemon_sleep_guide/utils/constants.dart';

class Ingredient {
  final String picture;
  final String name;
  final String description;
  final int baseStrength;
  final String sellValue;

  String get pictureUrl => "${Constants.serebiiBaseUrl}$picture";

  Ingredient(this.picture, this.name, this.description, this.baseStrength,
      this.sellValue);

  Ingredient.empty()
      : picture = "",
        name = "",
        description = "",
        baseStrength = 0,
        sellValue = "";

  Ingredient.fromJson(Map<String, dynamic> json)
      : picture = json['picture'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        baseStrength = json['baseStrength'] as int,
        sellValue = json['sellValue'] as String;

  Map<String, dynamic> toJson() => {
        'picture': picture,
        'name': name,
        'description': description,
        'baseStrength': baseStrength,
        'sellValue': sellValue,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
