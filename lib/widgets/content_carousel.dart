import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'content_card.dart';

class ContentCarousel extends StatelessWidget {
  final String title;
  final List<ContentModel> content;
  final Function(String) onContentTap;

  const ContentCarousel({
    super.key,
    required this.title,
    required this.content,
    required this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: content.length,
            itemBuilder: (context, index) {
              final item = content[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ContentCard(
                  content: item,
                  onTap: () => onContentTap(item.id),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}