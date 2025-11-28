import 'package:flutter/material.dart';

class QuickAccessSection extends StatelessWidget {
  final VoidCallback onWatchlistTap;
  final VoidCallback onMoviesTap;
  final VoidCallback onTVShowsTap;

  const QuickAccessSection({
    super.key,
    required this.onWatchlistTap,
    required this.onMoviesTap,
    required this.onTVShowsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickAccessCard(
                  icon: Icons.bookmark_rounded,
                  title: 'My Watchlist',
                  subtitle: 'Saved for later',
                  color: Colors.purple,
                  onTap: onWatchlistTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickAccessCard(
                  icon: Icons.movie_rounded,
                  title: 'Movies',
                  subtitle: 'Latest releases',
                  color: Colors.blue,
                  onTap: onMoviesTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickAccessCard(
                  icon: Icons.tv_rounded,
                  title: 'TV Shows',
                  subtitle: 'Binge worthy',
                  color: Colors.green,
                  onTap: onTVShowsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}