import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String heroTag;
  final Map<String, dynamic> pokemonDetail;
  final Color color;

  const DetailScreen({
    super.key,
    required this.heroTag,
    required this.pokemonDetail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: width * 0.9,
        height: height * 0.8,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: height * 0.35,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -55.5,
                        right: -55.5,
                        child: Image.asset(
                          'assets/pokeball.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        top: 21.5,
                        right: 20.5,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pokemonDetail['type']?.join(", ") ??
                                'No types available',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      Center(
                        child: Hero(
                          tag: heroTag,
                          child: CachedNetworkImage(
                            imageUrl: pokemonDetail['img'] ?? '',
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: Colors.red,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 240,
                        left: 20,
                        child: Text(
                          pokemonDetail['name'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 280,
                        left: 20,
                        child: Text(
                          "#${pokemonDetail['num'] ?? '000'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 320,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pokemonDetail['type']?.join(", ") ??
                                'No types available',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.35,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow(context, 'Name', pokemonDetail['name']),
                      buildInfoRow(context, 'Height', pokemonDetail['height']),
                      buildInfoRow(context, 'Weight', pokemonDetail['weight']),
                      buildInfoRow(
                          context, 'Spawn Time', pokemonDetail['spawn_time']),
                      buildInfoRow(context, 'Weakness',
                          pokemonDetail['weaknesses']?.join(", ")),
                      buildEvolutionRow(context, 'Pre Evolution',
                          pokemonDetail['prev_evolution'], 'Just Hatched'),
                      buildEvolutionRow(context, 'Next Evolution',
                          pokemonDetail['next_evolution'], 'Maxed Out'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(BuildContext context, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              label,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                value ?? 'Unknown',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEvolutionRow(BuildContext context, String label,
      List<dynamic>? evolutions, String defaultText) {
    if (evolutions == null || evolutions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                label,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  defaultText,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              label,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 20,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: evolutions.length,
                itemBuilder: (context, index) {
                  final isLastItem = index == evolutions.length - 1;
                  final currentEvolution = evolutions[index];

                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          currentEvolution['name'] ?? '',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                      if (!isLastItem) arrow(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget arrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        Icons.arrow_forward,
        size: 16,
        color: Colors.black,
      ),
    );
  }
}
