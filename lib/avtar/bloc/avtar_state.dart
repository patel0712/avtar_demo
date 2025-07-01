part of 'avtar_bloc.dart';

enum AvtarStatus { initial, loading, success, failure, loadingMore }

class AvatarState extends Equatable {
  final AvtarStatus status;
  final List<Avtar> avatars;
  final List<Avtar> filteredAvatars;
  final List<String> favorites;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const AvatarState({
    this.status = AvtarStatus.initial,
    this.avatars = const [],
    this.filteredAvatars = const [],
    this.favorites = const [],
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  AvatarState copyWith({
    AvtarStatus? status,
    List<Avtar>? avatars,
    List<Avtar>? filteredAvatars,
    List<String>? favorites,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return AvatarState(
      status: status ?? this.status,
      avatars: avatars ?? this.avatars,
      filteredAvatars: filteredAvatars ?? this.filteredAvatars,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    avatars,
    filteredAvatars,
    favorites,
    errorMessage,
    hasReachedMax,
    currentPage,
  ];
}