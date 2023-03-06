import 'biography.dart';
import 'server_image.dart';
import 'package:json_annotation/json_annotation.dart';
part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Superhero {
  final String name;
  final Biography biography;
  final ServerImage image;

  Superhero(this.name, this.biography, this.image);

  factory Superhero.fromJson(final Map<String, dynamic> json) => _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}
