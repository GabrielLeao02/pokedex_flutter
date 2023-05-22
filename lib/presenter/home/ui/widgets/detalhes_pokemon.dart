import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon/features/pokemon/data/model/pokemon_details_model.dart';
import 'package:pokemon/features/pokemon/domain/entities/specie.dart';
import 'package:pokemon/presenter/home/bloc/pokemon_specie_bloc.dart';
import 'package:pokemon/presenter/home/ui/widgets/flavor_text.dart';
import 'package:pokemon/presenter/home/ui/widgets/gender_rate_date.dart';
import 'package:pokemon/presenter/home/ui/widgets/information_pokemon.dart';

class DetalhesPokemon extends StatefulWidget {
  final PokemonDetailsModel item;
  const DetalhesPokemon({Key? key, required this.item}) : super(key: key);

  @override
  State<DetalhesPokemon> createState() => _DetalhesPokemonState();
}

class _DetalhesPokemonState extends State<DetalhesPokemon> {
  late PokemonSpecieBloc pokemonSpecieBloc;
  final themeData = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xffE8EDF2),
    ),
  );
  num height = 0.00;
  double weight = 0.00;

  @override
  void initState() {
    super.initState();
    pokemonSpecieBloc = GetIt.instance<PokemonSpecieBloc>();
    pokemonSpecieBloc.loadData(widget.item.species!.url);
    height = widget.item.height! / 10;
    weight = widget.item.weight! / 10;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Image.asset(
              'assets/pokemon-png-logo.png',
              width: 100,
              height: 60,
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.item.name!.substring(0, 1).toUpperCase() +
                        widget.item.name!.substring(1).toLowerCase(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(242, 242, 242, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Image.network(
                    widget.item.sprites!.backDefault!,
                    fit: BoxFit.fill,
                    height: 150,
                  ),
                ),
                FlavorText(pokemonSpecieBloc: pokemonSpecieBloc),
                _cardDetails()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _cardDetails() {
    return Card(
      color: const Color.fromRGBO(48, 166, 214, 1),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const InformationPokemon(
                        title: "Height",
                        color:  Color(0xffFFCC33),
                      ),
                      InformationPokemon(
                        title: "$height kg",
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      const InformationPokemon(
                          title: "Weight", color: Color(0xffFFCC33)),
                      InformationPokemon(
                        title: "$weight kg",
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      const InformationPokemon(
                        title: "Gender",
                        color: Color(0xffFFCC33),
                      ),
                      GenderRate(pokemonSpecieBloc: pokemonSpecieBloc),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const InformationPokemon(
                        title: "CategoryTiny",
                        color: Color(0xffFFCC33),
                      ),
                      _buildGenusText(),
                      const InformationPokemon(
                        title: "Abilities",
                        color: Color(0xffFFCC33),
                      ),
                      InformationPokemon(
                        title: widget.item.abilities![0].ability!.name!,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<Specie> _buildGenusText() {
    return StreamBuilder<Specie>(
      stream: pokemonSpecieBloc.listPokemonsStrem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String? genus;
          for (var entry in snapshot.data!.genera!) {
            if (entry.language!.name == "en") {
              genus = entry.genus;
              break;
            }
          }
          return InformationPokemon(
            title: genus.toString(),
            color: const Color.fromARGB(255, 255, 255, 255),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

