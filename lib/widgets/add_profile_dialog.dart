import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../utils/theme.dart';

class AddProfileDialog extends StatefulWidget {
  final ProfileController controller;

  const AddProfileDialog({
    super.key,
    required this.controller,
  });

  @override
  State<AddProfileDialog> createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<AddProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedAvatar = '';
  bool _isKidsProfile = false;
  String _selectedMaturityRating = 'All';
  List<String> _selectedGenres = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.controller.availableAvatars.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameField(),
                      const SizedBox(height: 20),
                      _buildAvatarSelection(),
                      const SizedBox(height: 20),
                      _buildKidsProfileToggle(),
                      const SizedBox(height: 20),
                      _buildMaturityRating(),
                      const SizedBox(height: 20),
                      _buildGenreSelection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.person_add_rounded,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Add New Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          style: IconButton.styleFrom(
            foregroundColor: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter profile name',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a profile name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAvatarSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Avatar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.controller.availableAvatars.length,
            itemBuilder: (context, index) {
              final avatar = widget.controller.availableAvatars[index];
              final isSelected = avatar == _selectedAvatar;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = avatar),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.surfaceColor,
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.secondaryTextColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKidsProfileToggle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kids Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Restrict content to kid-friendly options',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _isKidsProfile,
          onChanged: (value) {
            setState(() {
              _isKidsProfile = value;
              if (value) {
                _selectedMaturityRating = 'Kids';
              }
            });
          },
          activeColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildMaturityRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maturity Rating',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.controller.maturityRatings.map((rating) {
            final isSelected = rating == _selectedMaturityRating;
            final isDisabled = _isKidsProfile && rating != 'Kids';
            
            return FilterChip(
              label: Text(rating),
              selected: isSelected,
              onSelected: isDisabled ? null : (selected) {
                if (selected) {
                  setState(() => _selectedMaturityRating = rating);
                }
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenreSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favorite Genres (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.controller.availableGenres.map((genre) {
            final isSelected = _selectedGenres.contains(genre);
            
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedGenres.add(genre);
                  } else {
                    _selectedGenres.remove(genre);
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleCreateProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Create Profile'),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCreateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final success = await widget.controller.createProfile(
      name: _nameController.text.trim(),
      avatarUrl: _selectedAvatar,
      isKidsProfile: _isKidsProfile,
      favoriteGenres: _selectedGenres,
      maturityRating: _selectedMaturityRating,
    );
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile "${_nameController.text.trim()}" created successfully'),
          backgroundColor: AppTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}