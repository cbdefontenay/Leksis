import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:leksis/views/pages/home_page.dart';
import 'package:leksis/views/pages/setting_page.dart';
import 'package:leksis/views/widgets/navbar_widget.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      SettingPage(onLocaleChange: onLocaleChange),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Leksis")),
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
