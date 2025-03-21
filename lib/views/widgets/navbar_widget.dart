import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.workspace_premium),
              label: AppLocalizations.of(context)!.exercices,
            ),
            NavigationDestination(
              icon: Icon(Icons.zoom_in),
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
