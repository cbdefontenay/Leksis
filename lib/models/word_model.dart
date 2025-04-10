class Word {
  final int? id;
  final int folderId;
  final String word;
  final String translation;
  bool isLearned;

  Word({
    this.id,
    required this.folderId,
    required this.word,
    required this.translation,
    this.isLearned = false,
  });

  Word copyWith({
    int? id,
    int? folderId,
    String? word,
    String? translation,
    bool? isLearned,
  }) {
    return Word(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      isLearned: isLearned ?? this.isLearned,
    );
  }

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
