import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/content_carousel.dart';
import '../widgets/featured_content_banner.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/trending_section.dart';
import 'content_details_screen.dart';
import 'user_profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showSearchResults = false;
  bool _isSearchExpanded = false;
  late TabController _tabController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.categories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final dataService = Provider.of<DataService>(context, listen: false);
        dataService.setSelectedCategory(AppConstants.categories[_tabController.index]);
      }
    });
    
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showSearchResults = query.isNotEmpty;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        _showSearchResults = false;
        _searchFocusNode.unfocus();
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _onContentTap(String contentId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContentDetailsScreen(contentId: contentId),
      ),
    );
  }

  void _onProfileTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: _isSearchExpanded ? 140 : 100,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(
              (_scrollOffset / 100).clamp(0.0, 1.0),
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFBD001F), Color(0xFFE91E63)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppConstants.appName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A1A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Spacer(),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _isSearchExpanded ? size.width * 0.4 : 44,
                              height: 44,
                              child: _isSearchExpanded
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        onChanged: _onSearchChanged,
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: _toggleSearch,
                                            icon: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: _toggleSearch,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        child: const Icon(
                                          Icons.search_rounded,
                                          color: Colors.grey,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Consumer<DataService>(
                              builder: (context, dataService, child) {
                                final currentProfile = dataService.currentProfile;
                                return GestureDetector(
                                  onTap: _onProfileTap,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: currentProfile != null
                                          ? NetworkImage(currentProfile.avatarUrl)
                                          : null,
                                      child: currentProfile == null
                                          ? const Icon(
                                              Icons.person_rounded,
                                              size: 22,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        if (_isSearchExpanded) const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showSearchResults)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
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
                child: Consumer<DataService>(
                  builder: (context, dataService, child) {
                    final searchResults = dataService.searchContent(_searchController.text);
                    if (searchResults.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                Icons.search_off_rounded,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No results found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for something else',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: searchResults.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final content = searchResults[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                content.imageUrl,
                                width: 50,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.movie_rounded),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              content.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('${content.year} • ${content.genre}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Colors.amber[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      content.rating.toString(),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () => _onContentTap(content.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Consumer<DataService>(
                    builder: (context, dataService, child) {
                      final featuredContent = dataService.getContentByCategory('Trending');
                      if (featuredContent.isNotEmpty) {
                        return FeaturedContentBanner(
                          content: featuredContent.first,
                          onTap: () => _onContentTap(featuredContent.first.id),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  QuickAccessSection(
                    onWatchlistTap: () {
                      _tabController.animateTo(3);
                    },
                    onMoviesTap: () {
                      _tabController.animateTo(1);
                    },
                    onTVShowsTap: () {
                      _tabController.animateTo(2);
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<DataService>(
                    builder: (context, dataService, child) {
                      final trendingContent = dataService.getContentByCategory('Trending');
                      if (trendingContent.isNotEmpty) {
                        return TrendingSection(
                          content: trendingContent,
                          onContentTap: _onContentTap,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            indicator: BoxDecoration(
                              color: const Color(0xFFBD001F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey[600],
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            padding: const EdgeInsets.all(8),
                            tabs: AppConstants.categories.map((category) {
                              return Tab(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(category),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            controller: _tabController,
                            children: AppConstants.categories.map((category) {
                              return Consumer<DataService>(
                                builder: (context, dataService, child) {
                                  final content = dataService.getContentByCategory(category);
                                  if (content.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(40),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.movie_outlined,
                                              size: 30,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No content available',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return ContentCarousel(
                                    title: category,
                                    content: content,
                                    onContentTap: _onContentTap,
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
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
                    child: Text(
                      AppConstants.copyright,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }
}