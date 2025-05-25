// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get language => 'Nederlands';

  @override
  String get appTitle => 'Leksis';

  @override
  String get createFolder => 'Map aanmaken';

  @override
  String get createFolderHint => 'Mapnaam';

  @override
  String get createFolderError => 'Mapnaam mag niet leeg zijn';

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get saveButton => 'Opslaan';

  @override
  String get delete => 'Verwijderen';

  @override
  String get rename => 'Hernoemen';

  @override
  String get settings => 'Instellingen';

  @override
  String get home => 'Mappen';

  @override
  String get exercices => 'Oefeningen';

  @override
  String get overviewTitle => 'Overzicht';

  @override
  String get renameFolder => 'Map hernoemen';

  @override
  String get newFolderName => 'Nieuwe mapnaam';

  @override
  String get updateButton => 'Bijwerken';

  @override
  String get flashcards => 'Flashkaarten';

  @override
  String get guessTheWord => 'Raad het woord';

  @override
  String get words => 'woorden';

  @override
  String get word => 'woord';

  @override
  String get importList => 'Lijst importeren';

  @override
  String get exportList => 'Lijst exporteren';

  @override
  String get notLearned => 'Niet geleerd';

  @override
  String get learned => 'Geleerd';

  @override
  String get enterTheWord => 'Voer het woord in';

  @override
  String get attemptLeft => 'Pogingen over:';

  @override
  String get submit => 'Indienen';

  @override
  String get quizCompleted => 'Voltooid';

  @override
  String get score => 'Score';

  @override
  String get accuracy => 'Nauwkeurigheid';

  @override
  String get tryAgain => 'Probeer opnieuw';

  @override
  String get returnToFolder => 'Terug naar mappen';

  @override
  String get wordToPractice => 'Woorden om te oefenen';

  @override
  String get writeWordErrorMessage =>
      'Er zijn niet genoeg woorden in de lijst. Aantal:';

  @override
  String get validAnswer => 'Voer een geldig antwoord in';

  @override
  String get emptyFolderError => 'Deze map is leeg';

  @override
  String get failedLoadWords => 'Laden van de lijst mislukt';

  @override
  String get error => 'Fout';

  @override
  String get goBack => 'Terug';

  @override
  String get writeTheWord => 'Schrijf het woord';

  @override
  String get findThePair => 'Vind het paar';

  @override
  String get selectAFolder => 'Selecteer een map';

  @override
  String get exit => 'Afsluiten';

  @override
  String get changeLanguage => 'Taal wijzigen';

  @override
  String get translation => 'Vertaling';

  @override
  String get updateWord => 'Woord bijwerken';

  @override
  String get newWordName => 'Nieuw woord';

  @override
  String get add => 'Toevoegen';

  @override
  String get importFailMessage => 'Importeren mislukt:';

  @override
  String get excelProcessingError => 'Excel verwerkingsfout:';

  @override
  String get successImport => 'Succesvol geïmporteerd';

  @override
  String get noSheetFound => 'Geen bladen gevonden in Excel-bestand';

  @override
  String get notValidExcel => 'Geen geldig Excel-bestand';

  @override
  String get hereMyVocab => 'Hier is mijn woordenlijst';

  @override
  String get noFolder =>
      'Er zijn nog geen mappen, maak er een aan om ze te zien.';

  @override
  String get noWordsYet => 'Nog geen woorden toegevoegd!';

  @override
  String get addWordsPrompt => 'Tik op de + knop om woorden toe te voegen.';

  @override
  String get noWordForCategory => 'Geen woorden in deze categorie';

  @override
  String get markedAsLearned => 'Gemarkeerd als geleerd';

  @override
  String get markToBeLearned => 'Te leren markeren';

  @override
  String get learn => 'Leren';

  @override
  String get showtranslation => 'Eerst vertaling';

  @override
  String get allWords => 'Alle woorden';

  @override
  String get learnedWords => 'Geleerde woorden';

  @override
  String get wordsToLearn => 'Te leren woorden';

  @override
  String get sessionComplete => 'Sessie voltooid';

  @override
  String get youReviewed => 'Gefeliciteerd, alle woorden zijn beoordeeld!';

  @override
  String get restart => 'Opnieuw beginnen';

  @override
  String get changeMode => 'Modus wijzigen';

  @override
  String get reshuffle => 'Opnieuw schudden';

  @override
  String get fillFieldsError =>
      'Vul beide velden in voordat je een woord toevoegt.';

  @override
  String get selectNumberWords => 'Selecteer aantal woorden';

  @override
  String get loading => 'Laden...';

  @override
  String get changeWordCount => 'Aantal woorden wijzigen';

  @override
  String get createYourFirstFolder => 'Maak je eerste map aan om te beginnen';

  @override
  String get normal => 'Normaal';

  @override
  String get needFiveWords => 'Je hebt minstens 5 woorden nodig om te spelen.';

  @override
  String get gameOptions => 'Spelopties';

  @override
  String get difficulty => 'Moeilijkheidsgraad:';

  @override
  String get easy => 'Makkelijk';

  @override
  String get hard => 'Moeilijk';

  @override
  String get numberOfRounds => 'Aantal rondes:';

  @override
  String roundsCount(Object count) {
    return '$count rondes';
  }

  @override
  String get startGame => 'Spel starten';

  @override
  String get round => 'Ronde';

  @override
  String get matched => 'Gematched';

  @override
  String get pairs => 'paren';

  @override
  String get time => 'Tijd';

  @override
  String get seconds => 'seconden';

  @override
  String get secondsAbbr => 's';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get roundsWon => 'Rondes gewonnen';

  @override
  String get totalTime => 'Totale tijd';

  @override
  String get playAgain => 'Nog een keer spelen';

  @override
  String get backToOptions => 'Terug naar opties';

  @override
  String get loadingWords => 'Woorden laden...';

  @override
  String get noWordsAvailable => 'Geen woorden beschikbaar';

  @override
  String get correctAnswer => 'Juist antwoord';

  @override
  String get yourAnswer => 'Jouw antwoord';

  @override
  String get mistakes => 'Fouten:';

  @override
  String get noAnswer => 'Geen antwoord';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get system => 'Systeem';

  @override
  String get modus => 'Modus';

  @override
  String get learned2 => 'Geleerd';

  @override
  String get chooseWordCount => 'Kies aantal woorden';

  @override
  String get translateThis => 'Vertal dit';

  @override
  String nextWordIn(int seconds) {
    return 'Volgende woord in $seconds';
  }

  @override
  String get searchFolders => 'Mappen zoeken...';

  @override
  String get noResultsFound => 'Geen overeenkomende mappen gevonden';

  @override
  String get seeMoreWords => 'Meer woorden tonen';

  @override
  String showingWords(Object count, Object total) {
    return 'Toont $count van $total';
  }

  @override
  String get flashcardHelpTitle => 'Hoe flashkaarten te gebruiken';

  @override
  String get flashcardHelpMessage =>
      'Veeg naar rechts om als geleerd te markeren ✅\nVeeg naar links om als niet geleerd te markeren ❌\n\nOf tik op de kaart om deze om te draaien';

  @override
  String get flashcardHelpButton => 'Begrepen!';

  @override
  String get help => 'Hulp';

  @override
  String get aboutTheApp => 'Over de app';

  @override
  String get aboutTitle => 'Over Leksis';

  @override
  String get aboutContent1 =>
      'Leksis is een applicatie ontworpen om eenvoudig en effectief een of meer talen te leren. Het doel is niet om veel opties te hebben die weinig mensen gebruiken. Leksis is een plek waar gebruikers eenvoudig hun vocabulairewoorden of alledaagse zinnen kunnen opslaan en oefenen via gemakkelijk toegankelijke oefeningen.';

  @override
  String get aboutContent2 =>
      'Gegevens worden rechtstreeks op het apparaat van de gebruiker opgeslagen via een lokale SQLite-database, wat betekent dat de app offline werkt. Het delen van vocabulairelijsten met vrienden is echter alleen mogelijk door lijsten te exporteren of importeren via \".xlsx\"-bestanden uit gemaakte mappen.';

  @override
  String get aboutContent3 =>
      'Het voordeel is dat uw gegevens van u zijn en niemand anders er toegang toe heeft. Het nadeel is dat als er iets met uw telefoon gebeurt, u uw gegevens verliest tenzij u ze van tevoren heeft geëxporteerd.';
}
