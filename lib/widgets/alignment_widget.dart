import 'package:flutter/material.dart';

import '../model/alignment_info.dart';

class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;
  final BorderRadius borderRadius;

  const AlignmentWidget({super.key, required this.alignmentInfo, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        height: 24,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: alignmentInfo.color,
            borderRadius: borderRadius
        ),
        child: Text(
          alignmentInfo.name.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}