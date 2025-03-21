import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:leksis/views/pages/exercises_page.dart';
import 'package:leksis/views/pages/home_page.dart';
import 'package:leksis/views/pages/overview_page.dart';
import 'package:leksis/views/pages/setting_page.dart';
import 'package:leksis/views/widgets/navbar_widget.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      ExercicesPage(),
      OverviewPage(),
      SettingPage(onLocaleChange: onLocaleChange),
    ];

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
