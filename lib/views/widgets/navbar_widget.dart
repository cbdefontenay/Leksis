import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import '../../l10n/app_localizations.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedpage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.folder_copy),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center),
              label: AppLocalizations.of(context)!.exercices,
            ),
            NavigationDestination(
              icon: Icon(Icons.zoom_in_map),
              label: AppLocalizations.of(context)!.overviewTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedpage,
        );
      },
    );
  }
}
