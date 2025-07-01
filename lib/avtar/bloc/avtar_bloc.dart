import 'package:avtar_demo/data/api_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entity/avtar_model.dart';

part 'avtar_event.dart';
part 'avtar_state.dart';

class HomeBloc extends Bloc<AvtarEvent, AvatarState> {
  final ApiRepository _apiRepository;
  final int limit = 20;

  // Filter parameters
  String? _currentNameQuery;
  String? _currentGenderFilter;
  String? _currentAgeRangeFilter;

  HomeBloc() : _apiRepository = ApiRepository(), super(const AvatarState()) {
    on<FetchAvatars>(_onFetchAvatars);
    on<FetchMoreAvatars>(_onFetchMoreAvatars);
    on<FilterAvatars>(_onFilterAvatars);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onFetchAvatars(
    FetchAvatars event,
    Emitter<AvatarState> emit,
  ) async {
    try {
      if (event.refresh) {
        emit(state.copyWith(status: AvtarStatus.loading, currentPage: 1));
      } else if (state.status == AvtarStatus.initial) {
        emit(state.copyWith(status: AvtarStatus.loading));
      }

      final avtarModel = await _apiRepository.fetchAvtar(
        page: 1,
        results: limit,
        gender: _currentGenderFilter,
      );

      final avatars = avtarModel.results ?? [];

      emit(
        state.copyWith(
          status: AvtarStatus.success,
          avatars: avatars,
          filteredAvatars: _filterAvatars(avatars),
          hasReachedMax: avatars.length < limit,
          currentPage: 1,
        ),
      );
    } catch (e) {
      print("Error fetching avatars: $e");
      emit(
        state.copyWith(status: AvtarStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFetchMoreAvatars(
    FetchMoreAvatars event,
    Emitter<AvatarState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      emit(state.copyWith(status: AvtarStatus.loadingMore));

      final nextPage = state.currentPage + 1;
      final avtarModel = await _apiRepository.fetchAvtar(
        page: nextPage,
        results: limit,
        gender: _currentGenderFilter,
      );

      final newAvatars = avtarModel.results ?? [];
      final allAvatars = List<Avtar>.from(state.avatars)..addAll(newAvatars);

      emit(
        state.copyWith(
          status: AvtarStatus.success,
          avatars: allAvatars,
          filteredAvatars: _filterAvatars(allAvatars),
          hasReachedMax: newAvatars.length < limit,
          currentPage: nextPage,
        ),
      );
    } catch (e) {
      print("Error On fetching more avatars: $e");
      emit(
        state.copyWith(status: AvtarStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _onFilterAvatars(FilterAvatars event, Emitter<AvatarState> emit) {
    _currentNameQuery = event.nameQuery;
    _currentGenderFilter = event.genderFilter;
    _currentAgeRangeFilter = event.ageRangeFilter;

    final filteredAvatars = _filterAvatars(state.avatars);

    emit(state.copyWith(filteredAvatars: filteredAvatars));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<AvatarState> emit,
  ) async {
    final currentFavorites = List<String>.from(state.favorites);

    if (currentFavorites.contains(event.avatarId)) {
      currentFavorites.remove(event.avatarId);
    } else {
      currentFavorites.add(event.avatarId);
    }

    await _saveFavorites(currentFavorites);

    emit(state.copyWith(favorites: currentFavorites));
  }

  List<Avtar> _filterAvatars(List<Avtar> avatars) {
    var filtered = avatars;

    // Filter  name
    if (_currentNameQuery != null && _currentNameQuery!.isNotEmpty) {
      filtered =
          filtered.where((avatar) {
            final fullName =
                '${avatar.name?.first ?? ''} ${avatar.name?.last ?? ''}'
                    .toLowerCase();
            return fullName.contains(_currentNameQuery!.toLowerCase());
          }).toList();
    }

    // Filter gender
    if (_currentGenderFilter != null &&
        _currentGenderFilter!.isNotEmpty &&
        _currentGenderFilter != 'all') {
      filtered =
          filtered
              .where((avatar) => avatar.gender == _currentGenderFilter)
              .toList();
    }

    // Filter age 
    if (_currentAgeRangeFilter != null &&
        _currentAgeRangeFilter!.isNotEmpty &&
        _currentAgeRangeFilter != 'all') {
      filtered =
          filtered.where((avatar) {
            final age = avatar.dob?.age ?? 0;
            switch (_currentAgeRangeFilter) {
              case '18-30':
                return age >= 18 && age <= 30;
              case '31-45':
                return age >= 31 && age <= 45;
              case '46+':
                return age >= 46;
              default:
                return true;
            }
          }).toList();
    }

    return filtered;
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<AvatarState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];
      emit(state.copyWith(favorites: favorites));
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveFavorites(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', favorites);
    } catch (e) {
      print("Error saving favorites: $e");
    }
  }
}
