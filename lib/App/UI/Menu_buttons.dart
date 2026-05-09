<<<<<<< HEAD
import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final List<ActionItem> actions;
  final Color backgroundColor;

  const BottomActionBar({
    super.key,
    required this.actions,
    this.backgroundColor = const Color(0xFFB08968),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return _buildSmallActionBox(
            icon: action.icon,
            label: action.label,
            onTap: action.onTap,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSmallActionBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
=======
import 'package:flutter/cupertino.dart';

Container(
width: double.infinity,
decoration: const BoxDecoration(
color: Color(0xFFB08968), // Darker tan/beige box
// borderRadius: BorderRadius.only(
//   topLeft: Radius.circular(32),
//   topRight: Radius.circular(32),
// ),
),
padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
_buildSmallActionBox(
icon: Icons.history,
label: "History",
onTap: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (context) => const VideoPage(videoUrl: '',),
),
);
},
),
_buildSmallActionBox(
icon: Icons.save,
label: "Saved",
onTap: () {},
),
_buildSmallActionBox(
icon: Icons.settings,
label: "Settings",
onTap: () {},
),
],
),
),
>>>>>>> d3456fb870fb969f69dd10f596d22fa25282ff42
