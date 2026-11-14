import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../cubit/dictionary_cubit.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  void _playPronunciation(BuildContext context, String sinhala, String transliteration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('Pronouncing "$transliteration" ($sinhala)...'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.lightPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.translate_rounded, color: AppColors.lightPrimary),
            SizedBox(width: 8),
            Text('Offline Sinhala Dictionary'),
          ],
        ),
      ),
      body: BlocBuilder<DictionaryCubit, DictionaryState>(
        builder: (context, state) {
          if (state is DictionaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DictionaryLoaded) {
            final words = state.filteredWords;

            return Column(
              children: [
                // Search Header Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (val) => context.read<DictionaryCubit>().setSearchQuery(val),
                        decoration: InputDecoration(
                          hintText: 'Search English or Sinhala terms (e.g., Ayubowan)...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: state.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => context.read<DictionaryCubit>().setSearchQuery(''),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FilterChip(
                            avatar: Icon(
                              state.showOnlyBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              size: 16,
                              color: state.showOnlyBookmarked ? AppColors.accentOrange : null,
                            ),
                            label: const Text('Bookmarked Words'),
                            selected: state.showOnlyBookmarked,
                            onSelected: (_) => context.read<DictionaryCubit>().toggleBookmarkFilter(),
                          ),
                          const Spacer(),
                          Text(
                            '${words.length} terms found',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Dictionary Term List
                Expanded(
                  child: words.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'No Sinhala / English matching terms.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: words.length,
                          itemBuilder: (context, index) {
                            final word = words[index];

                            return CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              word.sinhala,
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${word.english} (${word.transliteration})',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _playPronunciation(
                                            context, word.sinhala, word.transliteration),
                                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.lightSecondary),
                                        tooltip: 'Listen Pronunciation',
                                      ),
                                      IconButton(
                                        onPressed: () => context
                                            .read<DictionaryCubit>()
                                            .toggleBookmarkWord(word.id),
                                        icon: Icon(
                                          word.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                          color: word.isBookmarked ? AppColors.accentOrange : Colors.grey,
                                        ),
                                        tooltip: 'Bookmark Word',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    word.definition,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      word.category,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
