part of 'avtar_bloc.dart';

abstract class AvtarEvent extends Equatable {
  const AvtarEvent();

  @override
  List<Object> get props => [];
}

class FetchAvatars extends AvtarEvent {
  final bool refresh;

  const FetchAvatars({this.refresh = false});
}

class FetchMoreAvatars extends AvtarEvent {}

class LoadFavorites extends AvtarEvent {}

class FilterAvatars extends AvtarEvent {
  final String? nameQuery;
  final String? genderFilter;
  final String? ageRangeFilter;

  const FilterAvatars({this.nameQuery, this.genderFilter, this.ageRangeFilter});

  @override
  List<Object> get props => [
    nameQuery ?? '',
    genderFilter ?? '',
    ageRangeFilter ?? '',
  ];
}

class ToggleFavorite extends AvtarEvent {
  final String avatarId;

  const ToggleFavorite(this.avatarId);

  @override
  List<Object> get props => [avatarId];
}
