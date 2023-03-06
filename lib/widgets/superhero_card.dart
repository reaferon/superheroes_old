import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard(
      {super.key,
      required this.superheroInfo,
      required this.onTap
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.indigo,
        ),

        child: Row(
          children: [
            CachedNetworkImage(imageUrl: superheroInfo.imageUrl, height: 70, width: 70, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(superheroInfo.name.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),),
                Text(superheroInfo.realName , style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
