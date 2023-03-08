import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  bool isNotNull() =>
    intelligence != "null" &&
    strength != "null" &&
    speed != "null" &&
    durability != "null" &&
    power != "null" &&
    combat != "null";

  double get intelligencePercent => convertStringValue(intelligence);
  double get strengthePercent => convertStringValue(strength);
  double get speedPercent => convertStringValue(speed);
  double get durabilityPercent => convertStringValue(durability);
  double get powerPercent => convertStringValue(power);
  double get combatPercent => convertStringValue(combat);

  double convertStringValue(value) {
    final intValue = int.tryParse(value);
    if(intValue == null) return 0;
    return intValue / 100;
  }

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
