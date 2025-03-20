import 'package:flutter/material.dart';

import 'package:leksis/data/notifiers.dart';

import 'package:leksis/database/database_helpers.dart';

import 'package:leksis/models/word_model.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  bool isLoading = true;

  final GlobalKey<AnimatedListState> _learnedListKey =
      GlobalKey<AnimatedListState>();

  final GlobalKey<AnimatedListState> _notLearnedListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> words = await _dbHelper.getWordsOverview();

    learnedWordsNotifier.value =
        words.where((word) => word.toBeLearned == false).toList();

    notLearnedWordsNotifier.value =
        words.where((word) => word.toBeLearned == true).toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleWordLearnStatus(Word word, int fromListIndex) async {
    await _dbHelper.toggleWordLearnStatus(word);

    if (fromListIndex == 0) {
      _removeWordWithAnimation(learnedWordsNotifier, _learnedListKey, word);

      _addWordWithAnimation(notLearnedWordsNotifier, _notLearnedListKey, word);
    } else {
      _removeWordWithAnimation(
        notLearnedWordsNotifier,

        _notLearnedListKey,

        word,
      );

      _addWordWithAnimation(learnedWordsNotifier, _learnedListKey, word);
    }

    word.toBeLearned = !word.toBeLearned;
  }

  void _removeWordWithAnimation(
    ValueNotifier<List<Word>> listNotifier,

    GlobalKey<AnimatedListState> listKey,

    Word word,
  ) {
    final list = listNotifier.value;

    final index = list.indexOf(word);

    if (index != -1) {
      listNotifier.value = List.from(list)..removeAt(index);

      listKey.currentState?.removeItem(
        index,

        (context, animation) => _buildRemovedItem(word, animation),
      );
    }
  }

  void _addWordWithAnimation(
    ValueNotifier<List<Word>> listNotifier,

    GlobalKey<AnimatedListState> listKey,

    Word word,
  ) {
    listNotifier.value = List.from(listNotifier.value)..insert(0, word);

    listKey.currentState?.insertItem(0);
  }

  Widget _buildRemovedItem(Word word, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,

      child: Card(
        margin: const EdgeInsets.all(8.0),

        child: ListTile(
          title: Text(word.word),

          subtitle: Text(word.translation),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),

        bottom: TabBar(
          controller: _tabController,

          tabs: const [Tab(text: "Learned"), Tab(text: "Not Learned")],
        ),
      ),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,

                children: [
                  _buildAnimatedWordList(
                    learnedWordsNotifier,

                    _learnedListKey,

                    0,
                  ),

                  _buildAnimatedWordList(
                    notLearnedWordsNotifier,

                    _notLearnedListKey,

                    1,
                  ),
                ],
              ),
    );
  }

  Widget _buildAnimatedWordList(
    ValueNotifier<List<Word>> wordsNotifier,

    GlobalKey<AnimatedListState> listKey,

    int listIndex,
  ) {
    return ValueListenableBuilder<List<Word>>(
      valueListenable: wordsNotifier,

      builder: (context, words, child) {
        if (words.isEmpty) {
          return const Center(child: Text("No words available"));
        }

        return AnimatedList(
          key: listKey,

          initialItemCount: words.length,

          itemBuilder: (context, index, animation) {
            final word = words[index];

            return _buildWordItem(word, animation, listIndex);
          },
        );
      },
    );
  }

  Widget _buildWordItem(Word word, Animation<double> animation, int listIndex) {
    return SizeTransition(
      sizeFactor: animation,

      child: Card(
        margin: const EdgeInsets.all(8.0),

        child: ListTile(
          title: Text(word.word),

          subtitle: Text(word.translation),

          trailing: IconButton(
            icon: Icon(
              word.toBeLearned ? Icons.star : Icons.star_border,

              color: word.toBeLearned ? Colors.deepPurple : Colors.grey,
            ),

            onPressed: () async {
              await _toggleWordLearnStatus(word, listIndex);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    learnedWordsNotifier.dispose();

    notLearnedWordsNotifier.dispose();

    super.dispose();
  }
}
