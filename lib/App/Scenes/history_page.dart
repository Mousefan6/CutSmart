import 'package:flutter/material.dart';
import '../UI/app_theme.dart';

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
    // Listen to accentColor changes so text updates instantly
    return ValueListenableBuilder(
      valueListenable: AppTheme.accentColor,
      builder: (context, Color accentColor, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor.value,
            appBar: AppBar(
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
                      bottom: BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.blue, // The specific blue line from your image
                    labelColor: accentColor,
                    unselectedLabelColor: accentColor.withOpacity(0.6),
                    tabs: const [
                      Tab(
                        child: Text(
                          "History",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Saved",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                _buildList(showOnlySaved: false, accentColor: accentColor), // History Tab
                _buildList(showOnlySaved: true, accentColor: accentColor),  // Saved Tab
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

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return Card(
          color: AppTheme.cardColor.value,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            onTap: () => _showPopup(item['name'], accentColor),
          ),
        );
      },
    );
  }

  // Logic to show themed popup
  void _showPopup(String name, Color accentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor.value,
        title: Text(
          name,
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Details for $name go here.",
          style: TextStyle(color: accentColor.withOpacity(0.9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  // Logic to update state (and eventually database)
  Future<void> _toggleSave(Map<String, dynamic> item) async {
    setState(() {
      item['isSaved'] = !item['isSaved'];
    });

    // This is where you will add your http.post to MongoDB
    print("Database sync: ${item['name']} isSaved = ${item['isSaved']}");
  }
}
