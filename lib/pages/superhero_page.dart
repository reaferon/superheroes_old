import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String id;

  const SuperheroPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final superhero = Superhero(
      id: "639",
      name: "Batman",
      biography: Biography(
        fullName: "Batman Andreevich",
        alignment: "good",
        aliases: ["Mouser", "Protektor"],
        placeOfBirth: "Russia, Moscow",
      ),
      image: ServerImage(
          "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"),
      powerstats: Powerstats(
        intelligence: "90",
        strength: "80",
        speed: "15",
        durability: "45",
        power: "100",
        combat: "0",
      ),
    );
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: CustomScrollView(
        slivers: [
          SuperheroAppBar(superhero: superhero),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (superhero.powerstats.isNotNull())
                  PowerstatsWidget(
                    powerstats: superhero.powerstats,
                  ),
                BiographyWidget(biography: superhero.biography)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({
    super.key,
    required this.superhero,
  });

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      backgroundColor: SuperheroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          superhero.name,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        background: CachedNetworkImage(
          imageUrl: superhero.image.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;

  const PowerstatsWidget({super.key, required this.powerstats});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Text(
        powerstats.toJson().toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Text(
        biography.toJson().toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
