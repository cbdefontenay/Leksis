import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:leksis/views/pages/home_page.dart';
import 'package:leksis/views/pages/setting_page.dart';
import 'package:leksis/views/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), SettingPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
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
