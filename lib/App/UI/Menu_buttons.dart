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
