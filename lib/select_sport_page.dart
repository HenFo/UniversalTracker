import 'package:flutter/material.dart';
import 'package:universal_tracker/base_map.dart';

class SelectSport extends StatelessWidget {
  const SelectSport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [SportsCard(title: "Inliner")],
      ),
    );
  }
}

class SportsCard extends StatelessWidget {
  final String title;
  const SportsCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BaseMapWithTracker()));
        },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(this.title)),
        ),
      ),
    );
  }
}
