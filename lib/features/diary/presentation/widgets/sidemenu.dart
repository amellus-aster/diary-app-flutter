// import 'package:deardiary/widgets/toggle.dart';
import 'package:deardiaryv2/features/diary/presentation/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          './../../../../assets/images/listDeco.png',
          height: 145,
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.44),
        ),
        SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.palette_rounded),
          title: Text(
            'Dark Theme',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
         
          trailing: ThemeToggle(),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Setting',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),

        ListTile(
          leading: Icon(Icons.share_rounded),
          title: Text(
            'Chia sẻ app',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
