class Word {
  int? id;

  int folderId;

  String word;

  String translation;

  bool isLearned;

  Word({
    this.id,

    required this.folderId,

    required this.word,

    required this.translation,

    this.isLearned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'folderId': folderId,

      'word': word,

      'translation': translation,

      'toBeLearned': isLearned ? 1 : 0,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],

      folderId: map['folderId'],

      word: map['word'],

      translation: map['translation'],

      isLearned: map['toBeLearned'] == 1,
    );
  }
}
