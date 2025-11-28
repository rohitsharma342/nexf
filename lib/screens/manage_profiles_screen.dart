import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_card.dart';
import '../widgets/add_profile_dialog.dart';
import '../widgets/edit_profile_dialog.dart';
import '../utils/theme.dart';

class ManageProfilesScreen extends StatelessWidget {
  const ManageProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(),
      child: const _ManageProfilesView(),
    );
  }
}

class _ManageProfilesView extends StatelessWidget {
  const _ManageProfilesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Consumer<ProfileController>(
                builder: (context, controller, child) {
                  if (controller.isLoading && controller.profiles.isEmpty) {
                    return _buildLoadingState();
                  }
                  
                  if (controller.error != null) {
                    return _buildErrorState(context, controller);
                  }
                  
                  return _buildProfilesList(context, controller);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<ProfileController>(
        builder: (context, controller, child) {
          return FloatingActionButton.extended(
            onPressed: () => _showAddProfileDialog(context, controller),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.person_add_rounded),
            label: const Text('Add Profile'),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceColor,
              foregroundColor: AppTheme.textColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Profiles',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create and customize viewing profiles',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.people_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading profiles...',
            style: TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ProfileController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.clearError();
                controller.loadProfiles();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesList(BuildContext context, ProfileController controller) {
    if (controller.profiles.isEmpty) {
      return _buildEmptyState(context, controller);
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadProfiles(),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverToBoxAdapter(
              child: _buildProfilesHeader(controller),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final profile = controller.profiles[index];
                  return ProfileCard(
                    profile: profile,
                    onEdit: () => _showEditProfileDialog(context, controller, profile),
                    onDelete: () => _handleDeleteProfile(context, controller, profile),
                  );
                },
                childCount: controller.profiles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesHeader(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${controller.profiles.length} Profile${controller.profiles.length != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Max 5 profiles',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ProfileController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Profiles Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first profile to get started with personalized content recommendations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.secondaryTextColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddProfileDialog(context, controller),
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Create Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context, ProfileController controller) {
    if (controller.profiles.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Maximum of 5 profiles allowed'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AddProfileDialog(controller: controller),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    ProfileController controller,
    profile,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        controller: controller,
        profile: profile,
      ),
    );
  }

  Future<void> _handleDeleteProfile(
    BuildContext context,
    ProfileController controller,
    profile,
  ) async {
    final success = await controller.deleteProfile(profile.id);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile "${profile.name}" deleted'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}