import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio_flutter/routes/route.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  AutoTabsScaffold(
      routes: const [
        DownloadPageRoute(),
        UploadPageRoute(),

      ],

      bottomNavigationBuilder: (_,tabs){
        return BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.tealAccent,
          currentIndex: tabs.activeIndex,
          onTap: tabs.setActiveIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.house, size: 40,), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.upload, size: 40,), label: 'Upload')
          ],
        );
      },
    );
  }
}
