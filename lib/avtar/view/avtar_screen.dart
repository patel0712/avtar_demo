import 'package:avtar_demo/avtar/bloc/avtar_bloc.dart';
import 'package:avtar_demo/avtar/view/favorites_screen.dart';
import 'package:avtar_demo/widgets/avtar_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AvtarScreen extends StatelessWidget {
  const AvtarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AvtarScreenContent();
  }
}

class AvtarScreenContent extends StatefulWidget {
  const AvtarScreenContent({super.key});

  @override
  State<AvtarScreenContent> createState() => _AvtarScreenContentState();
}

class _AvtarScreenContentState extends State<AvtarScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedGender = 'all';
  String _selectedAgeRange = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(FetchMoreAvatars());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(const FetchAvatars(refresh: true));
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: const FavoritesScreen(),
                      ),
                ),
              );
            },
            tooltip: 'View Favorites',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _searchAndFilterWidget(),
              const SizedBox(height: 8),
              _filterChips(),
              const SizedBox(height: 8),
              Expanded(child: _avatarListWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchAndFilterWidget() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search by name...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _showFilterDialog,
          icon: const Icon(Icons.filter_alt),
        ),
      ],
    );
  }

  Widget _filterChips() {
    return Row(
      children: [
        if (_selectedGender != 'all')
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('Gender: $_selectedGender'),
              onDeleted: () {
                setState(() {
                  _selectedGender = 'all';
                });
                _applyFilters();
              },
            ),
          ),
        if (_selectedAgeRange != 'all')
          Chip(
            label: Text('Age: $_selectedAgeRange'),
            onDeleted: () {
              setState(() {
                _selectedAgeRange = 'all';
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _avatarListWidget() {
    return BlocBuilder<HomeBloc, AvatarState>(
      builder: (context, state) {
        switch (state.status) {
          case AvtarStatus.loading:
            return _buildShimmerLoading();
          case AvtarStatus.failure:
            print(state.errorMessage);
            return _buildError(state.errorMessage ?? 'Unknown error occurred');
          case AvtarStatus.success:
          case AvtarStatus.loadingMore:
            if (state.filteredAvatars.isEmpty) {
              return const Center(
                child: Text('No avatars found', style: TextStyle(fontSize: 16)),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const FetchAvatars(refresh: true));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.filteredAvatars.length +
                    (state.status == AvtarStatus.loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.filteredAvatars.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return AvtarCardWidget(
                    avatar: state.filteredAvatars[index],
                    favorites: state.favorites,
                  );
                },
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(width: 100, height: 14, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 80, height: 14, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(const FetchAvatars(refresh: true));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<HomeBloc>().add(
      FilterAvatars(
        nameQuery: _searchController.text,
        genderFilter: _selectedGender,
        ageRangeFilter: _selectedAgeRange,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Avatars'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Age Range:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedAgeRange,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: '18-30', child: Text('18-30')),
                      DropdownMenuItem(value: '31-45', child: Text('31-45')),
                      DropdownMenuItem(value: '46+', child: Text('46+')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedAgeRange = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() {});
                    _applyFilters();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
