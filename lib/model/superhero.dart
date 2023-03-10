import 'biography.dart';
import 'powerstats.dart';
import 'server_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Superhero {
  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  Superhero({
    required this.id,
    required this.name,
    required this.biography,
    required this.image,
    required this.powerstats,
  });

  factory Superhero.fromJson(final Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

  @override
  String toString() {
    return 'Superhero{id: $id, name: $name, biography: $biography, image: $image, powerstats: $powerstats}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Superhero &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          biography == other.biography &&
          image == other.image &&
          powerstats == other.powerstats;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      biography.hashCode ^
      image.hashCode ^
      powerstats.hashCode;
}
