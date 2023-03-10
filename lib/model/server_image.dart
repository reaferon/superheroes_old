import 'package:json_annotation/json_annotation.dart';
part 'server_image.g.dart';


@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class ServerImage {
  final String url;

  ServerImage(this.url);

  factory ServerImage.fromJson(final Map<String, dynamic> json) => _$ServerImageFromJson(json);

  Map<String, dynamic> toJson() => _$ServerImageToJson(this);

  @override
  String toString() {
    return 'ServerImage{url: $url}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerImage &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}