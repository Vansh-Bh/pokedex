import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/details.dart';
import 'package:pokedex/theme_changer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> pokedex;
  late List<dynamic> filteredPokedex;
  String selectedType = 'All';
  String selectedWeakness = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    pokedex = [];
    filteredPokedex = [];
    fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          buildTitle(),
          buildSearchBar(),
          buildFilterOptions(),
          buildPokedexGrid(width),
          Positioned(
            top: 37,
            right: 20,
            child: Obx(
              () => IconButton(
                icon: Image.asset(
                  themeService.isDarkMode.value
                      ? 'assets/sun.png'
                      : 'assets/moon.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  themeService.switchTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Positioned(
      top: -40,
      right: -55,
      child: Image.asset(
        'assets/pokeball.png',
        width: 200,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget buildTitle() {
    return const Positioned(
      top: 60,
      left: 20,
      child: Text(
        'Pokedex',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 42,
            fontFamily: 'Pocket-Monk'),
      ),
    );
  }

  Widget buildSearchBar() {
    return Positioned(
      top: 130,
      left: 20,
      right: 20,
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
            filterPokemonList();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search Pokémon',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget buildFilterOptions() {
    return Positioned(
      top: 200,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDropdown(
            'Type',
            selectedType,
            _getTypeOptions(),
            (value) => setState(() {
              selectedType = value!;
              filterPokemonList();
            }),
          ),
          buildDropdown(
            'Weakness',
            selectedWeakness,
            getWeaknessOptions(),
            (value) => setState(() {
              selectedWeakness = value!;
              filterPokemonList();
            }),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String selectedValue, List<String> options,
      ValueChanged<String?>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: selectedValue,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildPokedexGrid(double width) {
    return Positioned(
      top: 260,
      bottom: 0,
      width: width,
      child: filteredPokedex.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
              ),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredPokedex.length,
              itemBuilder: (context, index) {
                return buildPokemonCard(index);
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
    );
  }

  Widget buildPokemonCard(int index) {
    final pokemon = filteredPokedex[index];
    final pokemonType = pokemon['type'][0];
    final pokemonColor = getPokemonColor(pokemonType);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () => showDetailDialog(index, pokemon, pokemonColor),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: Container(
              color: pokemonColor,
              child: Stack(
                children: [
                  buildPokeballBackground(),
                  buildPokemonImage(pokemon['img'], index),
                  buildPokemonType(pokemonType),
                  buildPokemonName(pokemon['name']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDetailDialog(int index, dynamic pokemonDetail, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DetailScreen(
          heroTag: index.toString(),
          pokemonDetail: pokemonDetail,
          color: color,
        );
      },
    );
  }

  Widget buildPokeballBackground() {
    return Positioned(
      bottom: -10,
      right: -10,
      child: Image.asset(
        'assets/pokeball.png',
        height: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget buildPokemonImage(String imageUrl, int index) {
    return Positioned(
      bottom: 5,
      right: 5,
      child: Hero(
        tag: index,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 100,
          fit: BoxFit.fitHeight,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPokemonType(String type) {
    return Positioned(
      top: 55,
      left: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Text(
          type,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            shadows: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0, 0),
                spreadRadius: 1.0,
                blurRadius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPokemonName(String name) {
    return Positioned(
      top: 30,
      left: 15,
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0, 0),
              spreadRadius: 1.0,
              blurRadius: 15,
            ),
          ],
        ),
      ),
    );
  }

  Color getPokemonColor(String type) {
    switch (type) {
      case "Grass":
        return Colors.greenAccent;
      case "Fire":
        return Colors.redAccent;
      case "Water":
        return Colors.blue;
      case "Poison":
        return Colors.deepPurpleAccent;
      case "Electric":
        return Colors.amber;
      case "Rock":
        return Colors.grey;
      case "Ground":
        return Colors.brown;
      case "Psychic":
        return Colors.indigo;
      case "Fighting":
        return Colors.orange;
      case "Bug":
        return Colors.lightGreenAccent;
      case "Ghost":
        return Colors.deepPurple;
      case "Normal":
        return Colors.grey;
      default:
        return Colors.pink;
    }
  }

  void fetchPokemonData() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pokedex = data['pokemon'];
          filteredPokedex = pokedex;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterPokemonList() {
    setState(() {
      filteredPokedex = pokedex.where((pokemon) {
        final typeMatch =
            selectedType == 'All' || pokemon['type'].contains(selectedType);
        final weaknessMatch = selectedWeakness == 'All' ||
            pokemon['weaknesses'].contains(selectedWeakness);
        final nameMatch = pokemon['name'].toLowerCase().contains(searchQuery);
        return typeMatch && weaknessMatch && nameMatch;
      }).toList();
    });
  }

  List<String> _getTypeOptions() {
    final types = pokedex.isNotEmpty
        ? pokedex
            .expand((pokemon) {
              return (pokemon['type'] as List<dynamic>).cast<String>();
            })
            .toSet()
            .toList()
        : <String>[];
    types.sort();
    return ['All'] + types;
  }

  List<String> getWeaknessOptions() {
    final weaknesses = pokedex.isNotEmpty
        ? pokedex
            .expand((pokemon) {
              return (pokemon['weaknesses'] as List<dynamic>).cast<String>();
            })
            .toSet()
            .toList()
        : <String>[];
    weaknesses.sort();
    return ['All'] + weaknesses;
  }
}
