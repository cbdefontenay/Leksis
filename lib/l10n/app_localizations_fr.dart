// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Français';

  @override
  String get appTitle => 'Leksis';

  @override
  String get createFolder => 'Créer un dossier';

  @override
  String get createFolderHint => 'Nom du dossier';

  @override
  String get createFolderError => 'Le nom du dossier ne peut pas être vide';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get saveButton => 'Sauvegarder';

  @override
  String get delete => 'Supprimer';

  @override
  String get rename => 'Renommer';

  @override
  String get settings => 'Paramètres';

  @override
  String get home => 'Dossiers';

  @override
  String get exercices => 'Exercices';

  @override
  String get overviewTitle => 'Historique';

  @override
  String get renameFolder => 'Renommer le dossier';

  @override
  String get newFolderName => 'Nouveau nom du dossier';

  @override
  String get updateButton => 'Mettre à jour';

  @override
  String get flashcards => 'Cartes mémoire';

  @override
  String get guessTheWord => 'Devine le mot';

  @override
  String get words => 'mots';

  @override
  String get word => 'mot';

  @override
  String get importList => 'Importer la liste';

  @override
  String get exportList => 'Exporter la liste';

  @override
  String get notLearned => 'A apprendre';

  @override
  String get learned => 'Appris';

  @override
  String get enterTheWord => 'Ecris le mot';

  @override
  String get attemptLeft => 'Tentatives restantes :';

  @override
  String get submit => 'Soumettre';

  @override
  String get quizCompleted => 'Terminé';

  @override
  String get score => 'Score';

  @override
  String get accuracy => 'Précision';

  @override
  String get tryAgain => 'Recommencer';

  @override
  String get returnToFolder => 'Retourner aux dossiers';

  @override
  String get wordToPractice => 'Mots à pratiquer';

  @override
  String get writeWordErrorMessage =>
      'Le nombre de mots dans la liste n\'est pas suffisant. Nombre actuel :';

  @override
  String get validAnswer => 'Entre une réponse valide';

  @override
  String get emptyFolderError => 'Ce dossier est vide';

  @override
  String get failedLoadWords => 'Impossible de charger la liste';

  @override
  String get error => 'Erreur';

  @override
  String get goBack => 'Retour';

  @override
  String get writeTheWord => 'Ecris le mot';

  @override
  String get findThePair => 'Trouve la paire';

  @override
  String get selectAFolder => 'Sélectionne un dossier';

  @override
  String get exit => 'Quitter';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get translation => 'Traduction';

  @override
  String get updateWord => 'Mettre à jour le mot';

  @override
  String get newWordName => 'Nouveau mot';

  @override
  String get add => 'Ajouter';

  @override
  String get importFailMessage => 'Échec de l\'importation :';

  @override
  String get excelProcessingError => 'Erreur de traitement Excel :';

  @override
  String get successImport => 'Importation réussie';

  @override
  String get noSheetFound => 'Aucune feuille trouvée dans le fichier Excel';

  @override
  String get notValidExcel => 'Fichier Excel non valide';

  @override
  String get hereMyVocab => 'Voici ma liste de vocabulaire';

  @override
  String get noFolder =>
      'Il n\'y a pas encore de dossier. Pourquoi pas en créer un ?';

  @override
  String get noWordsYet => 'Aucun mot ajouté pour le moment !';

  @override
  String get addWordsPrompt => 'Appuyez sur le bouton + pour ajouter des mots.';

  @override
  String get noWordForCategory => 'Aucun mot dans cette catégorie';

  @override
  String get markedAsLearned => 'Marqué comme appris';

  @override
  String get markToBeLearned => 'Marqué à apprendre';

  @override
  String get learn => 'Apprendre';

  @override
  String get showtranslation => 'Traduction en premier';

  @override
  String get allWords => 'Tous les mots';

  @override
  String get learnedWords => 'Mots appris';

  @override
  String get wordsToLearn => 'Mots à apprendre';

  @override
  String get sessionComplete => 'Session terminée';

  @override
  String get youReviewed => 'Félicitations, tous les mots ont été révisés !';

  @override
  String get restart => 'Redémarrer';

  @override
  String get changeMode => 'Changer de mode';

  @override
  String get reshuffle => 'Mélanger';

  @override
  String get fillFieldsError =>
      'Veuillez remplir tous les champs avant d\'ajouter un mot.';

  @override
  String get selectNumberWords => 'Sélectionnez un nombre de mots à travailler';

  @override
  String get loading => 'Chargement...';

  @override
  String get changeWordCount => 'Changer le nombre de mots';

  @override
  String get createYourFirstFolder =>
      'Créez votre premier dossier pour commencer';

  @override
  String get normal => 'Normal';

  @override
  String get needFiveWords => 'Vous avez besoin d\'au moins 5 mots pour jouer.';

  @override
  String get gameOptions => 'Options du jeu';

  @override
  String get difficulty => 'Difficulté :';

  @override
  String get easy => 'Facile';

  @override
  String get hard => 'Difficile';

  @override
  String get numberOfRounds => 'Nombre de tours :';

  @override
  String roundsCount(Object count) {
    return '$count tours';
  }

  @override
  String get startGame => 'Commencer le jeu';

  @override
  String get round => 'Tour';

  @override
  String get matched => 'Appariés';

  @override
  String get pairs => 'paires';

  @override
  String get time => 'Temps';

  @override
  String get seconds => 'secondes';

  @override
  String get secondsAbbr => 's';

  @override
  String get gameOver => 'Jeu terminé !';

  @override
  String get roundsWon => 'Tours gagnés';

  @override
  String get totalTime => 'Temps total';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get backToOptions => 'Retour aux options';

  @override
  String get loadingWords => 'Chargement des mots...';

  @override
  String get noWordsAvailable => 'Aucune liste disponible';

  @override
  String get correctAnswer => 'Bonne réponse';

  @override
  String get yourAnswer => 'Ta réponse';

  @override
  String get mistakes => 'Erreurs';

  @override
  String get noAnswer => 'Pas de réponse';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get modus => 'Mode';

  @override
  String get learned2 => 'Appris';

  @override
  String get chooseWordCount => 'Choisi le nombre de mots';

  @override
  String get translateThis => 'Traduis ceci';

  @override
  String nextWordIn(int seconds) {
    return 'Prochain mot dans $seconds';
  }

  @override
  String get searchFolders => 'Rechercher un dossier...';

  @override
  String get noResultsFound => 'Aucun dossier correspondant trouvé';

  @override
  String get seeMoreWords => 'Voir plus de mots';

  @override
  String showingWords(Object count, Object total) {
    return 'Affichage de $count sur $total';
  }

  @override
  String get flashcardHelpTitle => 'Comment utiliser les cartes mémoire';

  @override
  String get flashcardHelpMessage =>
      'Glisse vers la droite pour marquer comme appris ✅\nGlisse vers la gauche pour marquer comme non appris ❌\n\nOu appuis sur la carte pour la retourner';

  @override
  String get flashcardHelpButton => 'Compris!';

  @override
  String get help => 'Aide';

  @override
  String get aboutTheApp => 'À propos de l\'application';

  @override
  String get aboutTitle => 'À propos de Leksis';

  @override
  String get aboutContent1 =>
      'Leksis est une application conçue pour être simple et efficace dans l\'apprentissage d\'une ou plusieurs langues. L\'objectif n\'est pas d\'accumuler des options rarement utilisées. Leksis offre un espace où l\'utilisateur peut simplement stocker son vocabulaire ou des phrases du quotidien, et les travailler à travers des exercices ludiques et facilement accessibles.';

  @override
  String get aboutContent2 =>
      'Les données sont enregistrées directement sur l\'appareil de l\'utilisateur via une base de données SQLite locale, ce qui signifie que l\'application fonctionne hors connexion. Cependant, le partage de listes de vocabulaire avec des amis n\'est possible qu\'en exportant ou important des listes via des fichiers \".xlsx\" depuis les dossiers créés.';

  @override
  String get aboutContent3 =>
      'L\'avantage est que vos données vous appartiennent exclusivement. L\'inconvénient étant que si votre téléphone est endommagé ou perdu, vous perdrez vos données à moins de les avoir exportées au préalable.';
}
