// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get language => 'Deutsch';

  @override
  String get appTitle => 'Leksis';

  @override
  String get createFolder => 'Ordner erstellen';

  @override
  String get createFolderHint => 'Ordnername';

  @override
  String get createFolderError => 'Ordnername darf nicht leer sein';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get saveButton => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get home => 'Ordner';

  @override
  String get exercices => 'Übungen';

  @override
  String get overviewTitle => 'Übersicht';

  @override
  String get renameFolder => 'Ordner umbenennen';

  @override
  String get newFolderName => 'Neuer Ordnername';

  @override
  String get updateButton => 'Aktualisieren';

  @override
  String get flashcards => 'Karteikarten';

  @override
  String get guessTheWord => 'Wort erraten';

  @override
  String get words => 'Wörter';

  @override
  String get word => 'Wort';

  @override
  String get importList => 'Liste importieren';

  @override
  String get exportList => 'Liste exportieren';

  @override
  String get notLearned => 'Nicht gelernt';

  @override
  String get learned => 'Gelernt';

  @override
  String get enterTheWord => 'Schreibe das Wort';

  @override
  String get attemptLeft => 'Versuche übrig:';

  @override
  String get submit => 'Einreichen';

  @override
  String get quizCompleted => 'Abgeschlossen';

  @override
  String get score => 'Punktzahl';

  @override
  String get accuracy => 'Genauigkeit';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get returnToFolder => 'Zurück zu den Ordnern';

  @override
  String get wordToPractice => 'Wörter zum Üben';

  @override
  String get writeWordErrorMessage =>
      'Die Anzahl der Wörter in der Liste ist nicht ausreichend. Aktuelle Anzahl:';

  @override
  String get validAnswer => 'Geben Sie eine gültige Antwort ein';

  @override
  String get emptyFolderError => 'Dieser Ordner ist leer';

  @override
  String get failedLoadWords => 'Liste konnte nicht geladen werden';

  @override
  String get error => 'Fehler';

  @override
  String get goBack => 'Zurück';

  @override
  String get writeTheWord => 'Schreibe das Wort';

  @override
  String get findThePair => 'Finde das Paar';

  @override
  String get selectAFolder => 'Wähle einen Ordner';

  @override
  String get exit => 'Beenden';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get translation => 'Übersetzung';

  @override
  String get updateWord => 'Wort aktualisieren';

  @override
  String get newWordName => 'Neues Wort';

  @override
  String get add => 'Hinzufügen';

  @override
  String get importFailMessage => 'Import fehlgeschlagen:';

  @override
  String get excelProcessingError => 'Excel-Verarbeitungsfehler:';

  @override
  String get successImport => 'Erfolgreich importiert';

  @override
  String get noSheetFound =>
      'Keine Tabellenblätter in der Excel-Datei gefunden';

  @override
  String get notValidExcel => 'Keine gültige Excel-Datei';

  @override
  String get hereMyVocab => 'Hier ist meine Vokabelliste';

  @override
  String get noFolder =>
      'Es gibt noch keinen Ordner. Erstellen Sie einen, um ihn zu sehen.';

  @override
  String get noWordsYet => 'Noch keine Wörter hinzugefügt!';

  @override
  String get addWordsPrompt =>
      'Tippen Sie auf die + Schaltfläche, um Wörter hinzuzufügen.';

  @override
  String get noWordForCategory => 'Kein Wort in dieser Kategorie';

  @override
  String get markedAsLearned => 'Als gelernt markiert';

  @override
  String get markToBeLearned => 'Zum Lernen markiert';

  @override
  String get learn => 'Lernen';

  @override
  String get showtranslation => 'Übersetzung zuerst anzeigen';

  @override
  String get allWords => 'Alle Wörter';

  @override
  String get learnedWords => 'Gelernte Wörter';

  @override
  String get wordsToLearn => 'Wörter zum Lernen';

  @override
  String get sessionComplete => 'Sitzung abgeschlossen';

  @override
  String get youReviewed => 'Gratuliere, alle Wörter wurden überprüft!';

  @override
  String get restart => 'Neustarten';

  @override
  String get changeMode => 'Modus ändern';

  @override
  String get reshuffle => 'Neu mischen';

  @override
  String get fillFieldsError =>
      'Bitte füllen Sie alle Felder aus, bevor Sie ein Wort hinzufügen.';

  @override
  String get selectNumberWords => 'Wählen Sie eine Anzahl von Wörtern zu üben';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get changeWordCount => 'Wortanzahl ändern';

  @override
  String get createYourFirstFolder =>
      'Erstellen Sie Ihren ersten Ordner, um zu beginnen';

  @override
  String get normal => 'Normal';

  @override
  String get needFiveWords => 'Sie benötigen mindestens 5 Wörter zum Spielen.';

  @override
  String get gameOptions => 'Spieloptionen';

  @override
  String get difficulty => 'Schwierigkeit:';

  @override
  String get easy => 'Einfach';

  @override
  String get hard => 'Schwer';

  @override
  String get numberOfRounds => 'Anzahl der Runden:';

  @override
  String roundsCount(Object count) {
    return '$count Runden';
  }

  @override
  String get startGame => 'Spiel starten';

  @override
  String get round => 'Runde';

  @override
  String get matched => 'Gefunden';

  @override
  String get pairs => 'Paare';

  @override
  String get time => 'Zeit';

  @override
  String get seconds => 'Sekunden';

  @override
  String get secondsAbbr => 's';

  @override
  String get gameOver => 'Spiel beendet!';

  @override
  String get roundsWon => 'Gewonnene Runden';

  @override
  String get totalTime => 'Gesamtzeit';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get backToOptions => 'Zurück zur Auswahl';

  @override
  String get loadingWords => 'Wörter werden geladen...';

  @override
  String get noWordsAvailable => 'Keine Listen verfügbar';

  @override
  String get correctAnswer => 'Richtige Antwort';

  @override
  String get yourAnswer => 'Deine Antwort';

  @override
  String get mistakes => 'Fehler';

  @override
  String get noAnswer => 'Keine Antwort';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get modus => 'Modus';

  @override
  String get learned2 => 'Gelernt';

  @override
  String get chooseWordCount => 'Wörteranzahl wählen';

  @override
  String get translateThis => 'Übersetze dies';

  @override
  String nextWordIn(int seconds) {
    return 'Nächstes Wort in $seconds';
  }

  @override
  String get searchFolders => 'Ordner durchsuchen...';

  @override
  String get noResultsFound => 'Keine passenden Ordner gefunden';

  @override
  String get seeMoreWords => 'Mehr Wörter anzeigen';

  @override
  String showingWords(Object count, Object total) {
    return 'Zeige $count von $total';
  }

  @override
  String get flashcardHelpTitle => 'Wie man Karteikarten verwendet';

  @override
  String get flashcardHelpMessage =>
      'Nach rechts wischen, um als gelernt zu markieren ✅\nNach links wischen, um als ungelernt zu markieren ❌\n\nOder auf die Karte tippen, um sie umzudrehen';

  @override
  String get flashcardHelpButton => 'Verstanden!';

  @override
  String get help => 'Hilfe';

  @override
  String get aboutTheApp => 'Über die App';

  @override
  String get aboutTitle => 'Über Leksis';

  @override
  String get aboutContent1 =>
      'Leksis ist eine Anwendung, die einfach und effektiv das Lernen einer oder mehrerer Sprachen ermöglicht. Das Ziel ist nicht, viele Optionen anzubieten, die kaum genutzt werden. Leksis ist ein Ort, an dem Benutzer einfach ihre Vokabeln oder alltägliche Sätze speichern und sie durch leicht zugängliche Übungen lernen können.';

  @override
  String get aboutContent2 =>
      'Daten werden direkt auf dem Gerät des Benutzers in einer lokalen SQLite-Datenbank gespeichert, was bedeutet, dass die App offline funktioniert. Das Teilen von Vokabellisten mit Freunden ist jedoch nur möglich, indem Listen über \".xlsx\"-Dateien aus erstellten Ordnern exportiert oder importiert werden.';

  @override
  String get aboutContent3 =>
      'Der Vorteil ist, dass Ihre Daten Ihnen gehören und niemand sonst Zugriff darauf hat. Der Nachteil ist, dass Sie Ihre Daten verlieren, wenn Ihrem Telefon etwas zustößt, es sei denn, Sie haben sie vorher exportiert.';
}
