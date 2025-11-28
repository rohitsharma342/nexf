import 'package:flutter/material.dart';
import '../models/content_model.dart';
import '../widgets/content_card.dart';

class TrendingSection extends StatelessWidget {
  final List<ContentModel> content;
  final Function(String) onContentTap;

  const TrendingSection({
    super.key,
    required this.content,
    required this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBD001F), Color(0xFFE91E63)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Trending Now',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to see all trending content
                },
                child: Text(
                  'See All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFBD001F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: content.length > 10 ? 10 : content.length,
              itemBuilder: (context, index) {
                final item = content[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == content.length - 1 ? 0 : 16,
                  ),
                  child: Stack(
                    children: [
                      ContentCard(
                        content: item,
                        onTap: () => onContentTap(item.id),
                        width: 160,
                        height: 240,
                      ),
                      if (index < 3)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
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
      ),
    );
  }
}