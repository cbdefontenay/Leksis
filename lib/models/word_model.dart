class Word {
  int? id;

  int folderId;

  String word;

  String translation;

  bool toBeLearned;

  Word({
    this.id,

    required this.folderId,

    required this.word,

    required this.translation,

    this.toBeLearned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'folderId': folderId,

      'word': word,

      'translation': translation,

      'toBeLearned': toBeLearned ? 1 : 0,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],

      folderId: map['folderId'],

      word: map['word'],

      translation: map['translation'],

      toBeLearned: map['toBeLearned'] == 1,
    );
  }
}
