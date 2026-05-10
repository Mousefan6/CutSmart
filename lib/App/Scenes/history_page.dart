import 'package:flutter/material.dart';

import '../UI/app_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> items = [
    {"name": "Item 1", "isSaved": false},
    {"name": "Item 2", "isSaved": true},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFE3D8CD), // Your theme color
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('CutSmart', style: TextStyle(fontFamily: 'Georgia', fontSize: 24,
              fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, color: AppTheme.accentColor.value)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.accentColor.value, width: 2)),
              ),
              child: TabBar(
                indicatorColor: Colors.blue,
                labelColor: AppTheme.accentColor.value,
                unselectedLabelColor: AppTheme.accentColor.value.withOpacity(0.6),
                tabs: const [
                  Tab(child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  Tab(child: Text("Saved", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(showOnlySaved: false), // History Tab
            _buildList(showOnlySaved: true),  // Saved Tab
          ],
        ),
      ),
    );
  }

  Widget _buildList({required bool showOnlySaved}) {
    final displayItems = showOnlySaved
        ? items.where((i) => i['isSaved'] == true).toList()
        : items;

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return Card(
          color: AppTheme.cardColor.value,
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                item['isSaved'] ? Icons.star : Icons.star_border,
                color: Colors.black,
              ),
              onPressed: () => _toggleSave(item),
            ),
            title: Text(item['name'], style: const TextStyle(fontSize: 18)),
            onTap: () => _showPopup(item['name']),
          ),
        );
      },
    );
  }

  // Logic to show popup
  void _showPopup(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Text("Details for $name go here."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
        ],
      ),
    );
  }

  // Logic to update database and state
  Future<void> _toggleSave(Map<String, dynamic> item) async {
    setState(() {
      item['isSaved'] = !item['isSaved'];
    });

    // TODO: Add your http.post call here to update the 'Saved' status in MongoDB
    print("Updated ${item['name']} in database");
  }
}
