import 'package:flutter/material.dart';
import '../UI/app_theme.dart';
import '../UI/menu_buttons.dart'; // Import your menu bar

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> items = [
    {"name": "Carrot", "isSaved": false},
    {"name": "Potato", "isSaved": true},
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.accentColor,
      builder: (context, Color accentColor, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor.value,
            appBar: AppBar(
              automaticallyImplyLeading: false, // Prevents back button
              centerTitle: true,
              backgroundColor: AppTheme.backgroundColor.value,
              elevation: 0,
              title: Text(
                'CutSmart',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: accentColor.withOpacity(0.2), width: 1),
                    ),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: accentColor,
                    unselectedLabelColor: accentColor.withOpacity(0.6),
                    tabs: const [
                      Tab(child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      Tab(child: Text("Saved", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                // Expanded TabBarView lets the lists take up the middle space
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildList(showOnlySaved: false, accentColor: accentColor),
                      _buildList(showOnlySaved: true, accentColor: accentColor),
                    ],
                  ),
                ),
                // Bottom bar sits outside the Expanded area
                const BottomMenuBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList({required bool showOnlySaved, required Color accentColor}) {
    final displayItems = showOnlySaved
        ? items.where((i) => i['isSaved'] == true).toList()
        : items;

    if (displayItems.isEmpty) {
      return Center(
        child: Text(
          "Nothing here yet",
          style: TextStyle(color: accentColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return Card(
          color: AppTheme.cardColor.value,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                item['isSaved'] ? Icons.star : Icons.star_border,
                color: accentColor,
              ),
              onPressed: () => _toggleSave(item),
            ),
            title: Text(
              item['name'],
              style: TextStyle(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: accentColor.withOpacity(0.3)),
            onTap: () => _showPopup(item['name'], accentColor),
          ),
        );
      },
    );
  }

  void _showPopup(String name, Color accentColor) {
    showDialog(
        
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor.value,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          name,
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Details for $name go here.",
          style: TextStyle(color: accentColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Future<void> _toggleSave(Map<String, dynamic> item) async {
    setState(() {
      item['isSaved'] = !item['isSaved'];
    });
    // Placeholder for your MongoDB sync logic
    debugPrint("Database sync: ${item['name']} isSaved = ${item['isSaved']}");
  }
}
