// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get appTitle => 'Leksis';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get createFolderHint => 'Folder Name';

  @override
  String get createFolderError => 'Folder name cannot be empty';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get rename => 'Rename';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Folders';

  @override
  String get exercices => 'Exercises';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get renameFolder => 'Rename Folder';

  @override
  String get newFolderName => 'New Folder Name';

  @override
  String get updateButton => 'Update';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get guessTheWord => 'Guess the Word';

  @override
  String get words => 'words';

  @override
  String get word => 'word';

  @override
  String get importList => 'Import List';

  @override
  String get exportList => 'Export List';

  @override
  String get notLearned => 'Not Learned';

  @override
  String get learned => 'Learned';

  @override
  String get enterTheWord => 'Enter the word';

  @override
  String get attemptLeft => 'Attempts left :';

  @override
  String get submit => 'Submit';

  @override
  String get quizCompleted => 'Completed';

  @override
  String get score => 'Score';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get returnToFolder => 'Return to Folders';

  @override
  String get wordToPractice => 'Words to Practice';

  @override
  String get writeWordErrorMessage =>
      'The number of words in the list is not enough. Current number:';

  @override
  String get validAnswer => 'Enter a valid answer';

  @override
  String get emptyFolderError => 'This folder is empty';

  @override
  String get failedLoadWords => 'Failed to load the list';

  @override
  String get error => 'Error';

  @override
  String get goBack => 'Go Back';

  @override
  String get writeTheWord => 'Write the word';

  @override
  String get findThePair => 'Find the Pair';

  @override
  String get selectAFolder => 'Select a Folder';

  @override
  String get exit => 'Exit';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get translation => 'Translation';

  @override
  String get updateWord => 'Update word';

  @override
  String get newWordName => 'New word';

  @override
  String get add => 'Add';

  @override
  String get importFailMessage => 'Import failed:';

  @override
  String get excelProcessingError => 'Excel processing error:';

  @override
  String get successImport => 'Successfully imported';

  @override
  String get noSheetFound => 'No sheets found in Excel file';

  @override
  String get notValidExcel => 'Not a valid Excel File';

  @override
  String get hereMyVocab => 'Here my vocabulary list';

  @override
  String get noFolder => 'There is no folder yet, create one to see it.';

  @override
  String get noWordsYet => 'No words added yet!';

  @override
  String get addWordsPrompt => 'Tap the + button to start adding words.';

  @override
  String get noWordForCategory => 'No word in this category';

  @override
  String get markedAsLearned => 'Marked as learned';

  @override
  String get markToBeLearned => 'Marked to learn';

  @override
  String get learn => 'Learn';

  @override
  String get showtranslation => 'Translation first';

  @override
  String get allWords => 'All words';

  @override
  String get learnedWords => 'Learned words';

  @override
  String get wordsToLearn => 'Words to learn';

  @override
  String get sessionComplete => 'Session complete';

  @override
  String get youReviewed => 'Congratulations, all words have been reviewed!';

  @override
  String get restart => 'Restart';

  @override
  String get changeMode => 'Change Mode';

  @override
  String get reshuffle => 'Reshuffle';

  @override
  String get fillFieldsError =>
      'Please fill in both fields before adding a word.';

  @override
  String get selectNumberWords => 'Select a number of words';

  @override
  String get loading => 'Loading...';

  @override
  String get changeWordCount => 'Change Word Count';

  @override
  String get createYourFirstFolder => 'Create your first folder to get started';

  @override
  String get normal => 'Normal';

  @override
  String get needFiveWords => 'You need at least 5 words to play.';

  @override
  String get gameOptions => 'Game Options';

  @override
  String get difficulty => 'Difficulty:';

  @override
  String get easy => 'Easy';

  @override
  String get hard => 'Hard';

  @override
  String get numberOfRounds => 'Number of rounds:';

  @override
  String roundsCount(Object count) {
    return '$count rounds';
  }

  @override
  String get startGame => 'Start Game';

  @override
  String get round => 'Round';

  @override
  String get matched => 'Matched';

  @override
  String get pairs => 'pairs';

  @override
  String get time => 'Time';

  @override
  String get seconds => 'seconds';

  @override
  String get secondsAbbr => 's';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get roundsWon => 'Rounds Won';

  @override
  String get totalTime => 'Total Time';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToOptions => 'Back to options';

  @override
  String get loadingWords => 'Loading words...';

  @override
  String get noWordsAvailable => 'No words available';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get mistakes => 'Mistakes:';

  @override
  String get noAnswer => 'No answer';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get modus => 'Mode';

  @override
  String get learned2 => 'Learned';

  @override
  String get chooseWordCount => 'Choose word count';

  @override
  String get translateThis => 'Translate this';

  @override
  String nextWordIn(int seconds) {
    return 'Next word in $seconds';
  }

  @override
  String get searchFolders => 'Search folders...';

  @override
  String get noResultsFound => 'No matching folders found';

  @override
  String get seeMoreWords => 'See more words';

  @override
  String showingWords(Object count, Object total) {
    return 'Showing $count out of $total';
  }

  @override
  String get flashcardHelpTitle => 'How to use flashcards';

  @override
  String get flashcardHelpMessage =>
      'Swipe right to mark as learned ✅\nSwipe left to mark as unlearned ❌\n\nOr tap the card to flip it';

  @override
  String get flashcardHelpButton => 'Got it!';

  @override
  String get help => 'Help';

  @override
  String get aboutTheApp => 'About the app';

  @override
  String get aboutTitle => 'About Leksis';

  @override
  String get aboutContent1 =>
      'Leksis is an application designed to be simple and effective for learning one or more languages. The goal isn\'t to have lots of options that few people use. Leksis is a place where users can simply store their vocabulary words or everyday phrases, and practice them through easily accessible exercises.';

  @override
  String get aboutContent2 =>
      'Data is stored directly on the user\'s device via a local SQLite database, which means the app works offline. However, sharing vocabulary lists with friends is only possible by exporting or importing lists via \".xlsx\" files from created folders.';

  @override
  String get aboutContent3 =>
      'The advantage is that your data belongs to you and no one else has access to it. The disadvantage is that if something happens to your phone, you\'ll lose your data unless you\'ve exported it beforehand.';

  @override
  String get changePronunciationLanguage => 'Change pronunciation language';

  @override
  String get pronounceWord => 'Pronounce word';

  @override
  String get selectPronounciationWord => 'Select Pronunciation Language';

  @override
  String pronounciationMessageSet(Object selectedLanguage) {
    return 'Pronunciation language set to $selectedLanguage for this folder';
  }

  @override
  String get errorChangingLanguage => 'Error changing language...';

  @override
  String get unableSpeakWord =>
      'Unable to pronounce word. Trying to reinitialize...';

  @override
  String get enjoyingApp => 'Enjoying Leksis?';

  @override
  String get ratingPrompt =>
      'Would you mind rating Leksis on the Play Store? It helps us improve!';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get rateNow => 'Rate Now';

  @override
  String get thankYou => 'Thank you for your support!';
}
