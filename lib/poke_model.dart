import 'dart:core';

class Pokedex {
  List<Pokemon>? pokemon;

  Pokedex({this.pokemon});

  factory Pokedex.fromJson(Map<String, dynamic> json) {
    return Pokedex(
      pokemon: (json['pokemon'] as List<dynamic>?)
          ?.map((item) => Pokemon.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pokemon': pokemon?.map((v) => v.toJson()).toList(),
    };
  }
}

class Pokemon {
  int? id;
  String? num;
  String? name;
  String? img;
  List<String>? type;
  String? height;
  String? weight;
  String? candy;
  int? candyCount;
  String? egg;
  double? spawnChance;
  double? avgSpawns;
  String? spawnTime;
  List<double>? multipliers;
  List<String>? weaknesses;
  List<NextEvolution>? nextEvolution;

  Pokemon({
    this.id,
    this.num,
    this.name,
    this.img,
    this.type,
    this.height,
    this.weight,
    this.candy,
    this.candyCount,
    this.egg,
    this.spawnChance,
    this.avgSpawns,
    this.spawnTime,
    this.multipliers,
    this.weaknesses,
    this.nextEvolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int?,
      num: json['num'] as String?,
      name: json['name'] as String?,
      img: json['img'] as String?,
      type: (json['type'] as List<dynamic>?)?.cast<String>(),
      height: json['height'] as String?,
      weight: json['weight'] as String?,
      candy: json['candy'] as String?,
      candyCount: json['candy_count'] as int?,
      egg: json['egg'] as String?,
      spawnChance: (json['spawn_chance'])?.toDouble(),
      avgSpawns: (json['avg_spawns'])?.toDouble(),
      spawnTime: json['spawn_time'] as String?,
      multipliers: (json['multipliers'] as List<dynamic>?)?.cast<double>(),
      weaknesses: (json['weaknesses'] as List<dynamic>?)?.cast<String>(),
      nextEvolution: (json['next_evolution'] as List<dynamic>?)
          ?.map((item) => NextEvolution.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
      'name': name,
      'img': img,
      'type': type,
      'height': height,
      'weight': weight,
      'candy': candy,
      'candy_count': candyCount,
      'egg': egg,
      'spawn_chance': spawnChance,
      'avg_spawns': avgSpawns,
      'spawn_time': spawnTime,
      'multipliers': multipliers,
      'weaknesses': weaknesses,
      'next_evolution': nextEvolution?.map((v) => v.toJson()).toList(),
    };
  }
}

class NextEvolution {
  String? num;
  String? name;

  NextEvolution({this.num, this.name});

  factory NextEvolution.fromJson(Map<String, dynamic> json) {
    return NextEvolution(
      num: json['num'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'name': name,
    };
  }
}
