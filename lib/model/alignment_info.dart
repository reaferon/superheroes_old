import 'package:superheroes/resources/superheroes_colors.dart';
import 'dart:ui';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._(this.name, this.color);

  static const bad = AlignmentInfo._("bad", SuperheroesColors.red);
  static const good = AlignmentInfo._("good", SuperheroesColors.green);
  static const neutral = AlignmentInfo._("neutral", SuperheroesColors.grey);

  static AlignmentInfo? fromAlignment(final String alignment) {
    if(alignment == 'bad') {
      return bad;
    } else if(alignment == 'good') {
      return good;
    } else if(alignment == 'neutral') {
      return neutral;
    }
    return null;
  }
}