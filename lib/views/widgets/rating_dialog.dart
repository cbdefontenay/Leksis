import 'package:flutter/material.dart';
import 'package:leksis/l10n/app_localizations.dart';

class RatingDialog extends StatelessWidget {
  final VoidCallback onRated;
  final VoidCallback onLater;

  const RatingDialog({super.key, required this.onRated, required this.onLater});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.enjoyingApp),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Five stars instead of one
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(Icons.star, size: 32, color: Colors.amber),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.ratingPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onLater,
          child: Text(AppLocalizations.of(context)!.maybeLater),
        ),
        TextButton(
          onPressed: onRated,
          child: Text(AppLocalizations.of(context)!.rateNow),
        ),
      ],
    );
  }
}
