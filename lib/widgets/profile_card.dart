import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../utils/theme.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProfileInfo(),
                ),
                if (showActions) _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: profile.isKidsProfile 
              ? Colors.orange.withOpacity(0.3)
              : AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          profile.avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.surfaceColor,
              child: Icon(
                Icons.person,
                size: 30,
                color: AppTheme.secondaryTextColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (profile.isKidsProfile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kids',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Last used ${_formatLastUsed()}',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 14,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              profile.maturityRating,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (profile.favoriteGenres.isNotEmpty) ..[
              const SizedBox(width: 12),
              Icon(
                Icons.favorite_rounded,
                size: 14,
                color: Colors.red.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  profile.favoriteGenres.take(2).join(', '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_rounded,
              size: 20,
            ),
            style: IconButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
            ),
          ),
        const SizedBox(width: 8),
        if (onDelete != null)
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: const Icon(
              Icons.delete_rounded,
              size: 20,
            ),
            style: IconButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
            ),
          ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete "${profile.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatLastUsed() {
    final now = DateTime.now();
    final difference = now.difference(profile.lastUsed);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}