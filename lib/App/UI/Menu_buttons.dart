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
