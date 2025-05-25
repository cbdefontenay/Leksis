import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
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
    if (!mounted) return;

    List<Word> words = await _dbHelper.getWordsOverview();

    if (!mounted) return;

    learnedWordsNotifier.value =
        words.where((word) => word.isLearned == false).toList();
    notLearnedWordsNotifier.value =
        words.where((word) => word.isLearned == true).toList();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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

    word.isLearned = !word.isLearned;
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
        title: Text(
          AppLocalizations.of(context)!.overviewTitle,
          style: GoogleFonts.philosopher(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        bottom: TabBar(
          key: const ValueKey('overview_tab_bar'),
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onTertiary,
          indicatorWeight: 3,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelColor: Theme.of(context).colorScheme.onTertiary,
          unselectedLabelColor: Theme.of(context).colorScheme.onTertiary,
          labelStyle: GoogleFonts.firaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.firaSans(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              key: const ValueKey('not_learned_tab'),
              icon: Icon(
                Icons.star_border,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              text: AppLocalizations.of(context)!.notLearned,
            ),
            Tab(
              key: const ValueKey('learned_tab'),
              icon: Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              text: AppLocalizations.of(context)!.learned,
            ),
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<List<Word>>(
      valueListenable: wordsNotifier,
      builder: (context, words, child) {
        if (isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.loadingWords,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }

        if (words.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 64, color: colorScheme.primary),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '0 ${AppLocalizations.of(context)!.words}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noWordsAvailable,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${words.length} ${words.length == 1 ? AppLocalizations.of(context)!.word : AppLocalizations.of(context)!.words}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: listKey,
                initialItemCount: words.length,
                itemBuilder: (context, index, animation) {
                  final word = words[index];
                  return _buildWordItem(word, animation, listIndex);
                },
              ),
            ),
          ],
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
              word.isLearned ? Icons.star : Icons.star_border,
              color:
                  word.isLearned
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
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

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      _loadWords();
    }
  }

  @override
  void didUpdateWidget(covariant OverviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      setState(() {});
    }
  }
}
