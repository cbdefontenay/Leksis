import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Leksis'**
  String get appTitle;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @createFolderHint.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get createFolderHint;

  /// No description provided for @createFolderError.
  ///
  /// In en, this message translates to:
  /// **'Folder name cannot be empty'**
  String get createFolderError;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get home;

  /// No description provided for @exercices.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercices;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @renameFolder.
  ///
  /// In en, this message translates to:
  /// **'Rename Folder'**
  String get renameFolder;

  /// No description provided for @newFolderName.
  ///
  /// In en, this message translates to:
  /// **'New Folder Name'**
  String get newFolderName;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @guessTheWord.
  ///
  /// In en, this message translates to:
  /// **'Guess the Word'**
  String get guessTheWord;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'words'**
  String get words;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get word;

  /// No description provided for @importList.
  ///
  /// In en, this message translates to:
  /// **'Import List'**
  String get importList;

  /// No description provided for @exportList.
  ///
  /// In en, this message translates to:
  /// **'Export List'**
  String get exportList;

  /// No description provided for @notLearned.
  ///
  /// In en, this message translates to:
  /// **'Not Learned'**
  String get notLearned;

  /// No description provided for @learned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learned;

  /// No description provided for @enterTheWord.
  ///
  /// In en, this message translates to:
  /// **'Enter the word'**
  String get enterTheWord;

  /// No description provided for @attemptLeft.
  ///
  /// In en, this message translates to:
  /// **'Attempts left :'**
  String get attemptLeft;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get quizCompleted;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @returnToFolder.
  ///
  /// In en, this message translates to:
  /// **'Return to Folders'**
  String get returnToFolder;

  /// No description provided for @wordToPractice.
  ///
  /// In en, this message translates to:
  /// **'Words to Practice'**
  String get wordToPractice;

  /// No description provided for @writeWordErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The number of words in the list is not enough. Current number:'**
  String get writeWordErrorMessage;

  /// No description provided for @validAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid answer'**
  String get validAnswer;

  /// No description provided for @emptyFolderError.
  ///
  /// In en, this message translates to:
  /// **'This folder is empty'**
  String get emptyFolderError;

  /// No description provided for @failedLoadWords.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the list'**
  String get failedLoadWords;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @writeTheWord.
  ///
  /// In en, this message translates to:
  /// **'Write the word'**
  String get writeTheWord;

  /// No description provided for @findThePair.
  ///
  /// In en, this message translates to:
  /// **'Find the Pair'**
  String get findThePair;

  /// No description provided for @selectAFolder.
  ///
  /// In en, this message translates to:
  /// **'Select a Folder'**
  String get selectAFolder;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @updateWord.
  ///
  /// In en, this message translates to:
  /// **'Update word'**
  String get updateWord;

  /// No description provided for @newWordName.
  ///
  /// In en, this message translates to:
  /// **'New word'**
  String get newWordName;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @importFailMessage.
  ///
  /// In en, this message translates to:
  /// **'Import failed:'**
  String get importFailMessage;

  /// No description provided for @excelProcessingError.
  ///
  /// In en, this message translates to:
  /// **'Excel processing error:'**
  String get excelProcessingError;

  /// No description provided for @successImport.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported'**
  String get successImport;

  /// No description provided for @noSheetFound.
  ///
  /// In en, this message translates to:
  /// **'No sheets found in Excel file'**
  String get noSheetFound;

  /// No description provided for @notValidExcel.
  ///
  /// In en, this message translates to:
  /// **'Not a valid Excel File'**
  String get notValidExcel;

  /// No description provided for @hereMyVocab.
  ///
  /// In en, this message translates to:
  /// **'Here my vocabulary list'**
  String get hereMyVocab;

  /// No description provided for @noFolder.
  ///
  /// In en, this message translates to:
  /// **'There is no folder yet, create one to see it.'**
  String get noFolder;

  /// No description provided for @noWordsYet.
  ///
  /// In en, this message translates to:
  /// **'No words added yet!'**
  String get noWordsYet;

  /// No description provided for @addWordsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to start adding words.'**
  String get addWordsPrompt;

  /// No description provided for @noWordForCategory.
  ///
  /// In en, this message translates to:
  /// **'No word in this category'**
  String get noWordForCategory;

  /// No description provided for @markedAsLearned.
  ///
  /// In en, this message translates to:
  /// **'Marked as learned'**
  String get markedAsLearned;

  /// No description provided for @markToBeLearned.
  ///
  /// In en, this message translates to:
  /// **'Marked to learn'**
  String get markToBeLearned;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @showtranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation first'**
  String get showtranslation;

  /// No description provided for @allWords.
  ///
  /// In en, this message translates to:
  /// **'All words'**
  String get allWords;

  /// No description provided for @learnedWords.
  ///
  /// In en, this message translates to:
  /// **'Learned words'**
  String get learnedWords;

  /// No description provided for @wordsToLearn.
  ///
  /// In en, this message translates to:
  /// **'Words to learn'**
  String get wordsToLearn;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get sessionComplete;

  /// No description provided for @youReviewed.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, all words have been reviewed!'**
  String get youReviewed;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @changeMode.
  ///
  /// In en, this message translates to:
  /// **'Change Mode'**
  String get changeMode;

  /// No description provided for @reshuffle.
  ///
  /// In en, this message translates to:
  /// **'Reshuffle'**
  String get reshuffle;

  /// No description provided for @fillFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both fields before adding a word.'**
  String get fillFieldsError;

  /// No description provided for @selectNumberWords.
  ///
  /// In en, this message translates to:
  /// **'Select a number of words'**
  String get selectNumberWords;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @changeWordCount.
  ///
  /// In en, this message translates to:
  /// **'Change Word Count'**
  String get changeWordCount;

  /// No description provided for @createYourFirstFolder.
  ///
  /// In en, this message translates to:
  /// **'Create your first folder to get started'**
  String get createYourFirstFolder;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @needFiveWords.
  ///
  /// In en, this message translates to:
  /// **'You need at least 5 words to play.'**
  String get needFiveWords;

  /// No description provided for @gameOptions.
  ///
  /// In en, this message translates to:
  /// **'Game Options'**
  String get gameOptions;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty:'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @numberOfRounds.
  ///
  /// In en, this message translates to:
  /// **'Number of rounds:'**
  String get numberOfRounds;

  /// No description provided for @roundsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rounds'**
  String roundsCount(Object count);

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @round.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// No description provided for @matched.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get matched;

  /// No description provided for @pairs.
  ///
  /// In en, this message translates to:
  /// **'pairs'**
  String get pairs;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @secondsAbbr.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsAbbr;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get gameOver;

  /// No description provided for @roundsWon.
  ///
  /// In en, this message translates to:
  /// **'Rounds Won'**
  String get roundsWon;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToOptions.
  ///
  /// In en, this message translates to:
  /// **'Back to options'**
  String get backToOptions;

  /// No description provided for @loadingWords.
  ///
  /// In en, this message translates to:
  /// **'Loading words...'**
  String get loadingWords;

  /// No description provided for @noWordsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No words available'**
  String get noWordsAvailable;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get yourAnswer;

  /// No description provided for @mistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes:'**
  String get mistakes;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get noAnswer;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @modus.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get modus;

  /// No description provided for @learned2.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learned2;

  /// Prompt to select how many words to practice
  ///
  /// In en, this message translates to:
  /// **'Choose word count'**
  String get chooseWordCount;

  /// Instruction to translate the displayed word
  ///
  /// In en, this message translates to:
  /// **'Translate this'**
  String get translateThis;

  /// Countdown message showing when next word will appear
  ///
  /// In en, this message translates to:
  /// **'Next word in {seconds}'**
  String nextWordIn(int seconds);

  /// Placeholder text for folder search input field
  ///
  /// In en, this message translates to:
  /// **'Search folders...'**
  String get searchFolders;

  /// Message shown when no folders match the search query
  ///
  /// In en, this message translates to:
  /// **'No matching folders found'**
  String get noResultsFound;

  /// No description provided for @seeMoreWords.
  ///
  /// In en, this message translates to:
  /// **'See more words'**
  String get seeMoreWords;

  /// No description provided for @showingWords.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} out of {total}'**
  String showingWords(Object count, Object total);

  /// No description provided for @flashcardHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use flashcards'**
  String get flashcardHelpTitle;

  /// No description provided for @flashcardHelpMessage.
  ///
  /// In en, this message translates to:
  /// **'Swipe right to mark as learned ✅\nSwipe left to mark as unlearned ❌\n\nOr tap the card to flip it'**
  String get flashcardHelpMessage;

  /// No description provided for @flashcardHelpButton.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get flashcardHelpButton;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutTheApp;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Leksis'**
  String get aboutTitle;

  /// No description provided for @aboutContent1.
  ///
  /// In en, this message translates to:
  /// **'Leksis is an application designed to be simple and effective for learning one or more languages. The goal isn\'t to have lots of options that few people use. Leksis is a place where users can simply store their vocabulary words or everyday phrases, and practice them through easily accessible exercises.'**
  String get aboutContent1;

  /// No description provided for @aboutContent2.
  ///
  /// In en, this message translates to:
  /// **'Data is stored directly on the user\'s device via a local SQLite database, which means the app works offline. However, sharing vocabulary lists with friends is only possible by exporting or importing lists via \".xlsx\" files from created folders.'**
  String get aboutContent2;

  /// No description provided for @aboutContent3.
  ///
  /// In en, this message translates to:
  /// **'The advantage is that your data belongs to you and no one else has access to it. The disadvantage is that if something happens to your phone, you\'ll lose your data unless you\'ve exported it beforehand.'**
  String get aboutContent3;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
