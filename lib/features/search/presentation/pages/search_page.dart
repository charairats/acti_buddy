import 'package:flutter/material.dart';

class SearchActivityPage extends StatefulWidget {
  const SearchActivityPage({super.key});

  @override
  State<SearchActivityPage> createState() => _SearchActivityPageState();
}

class _SearchActivityPageState extends State<SearchActivityPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search for events, friends...",
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
      body: ListView(
        children: [
          Text('ช่องค้นหา (Search Bar)', style: TextStyle(color: cs.onSurface)),
          Text(
            'ประวัติการค้นหาล่าสุด (Recent Searches)',
            style: TextStyle(color: cs.onSurface),
          ),
          Text(
            'คำค้นหายอดนิยม (Trending Searches)',
            style: TextStyle(color: cs.onSurface),
          ),
          Text(
            'สำรวจตามหมวดหมู่ (Browse by Category)',
            style: TextStyle(color: cs.onSurface),
          ),
          Text(
            'แนะนำสำหรับคุณ (Recommended for You)',
            style: TextStyle(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
