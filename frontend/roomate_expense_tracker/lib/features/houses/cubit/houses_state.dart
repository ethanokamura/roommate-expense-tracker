part of 'houses_cubit.dart';

/// Represents the different states a post can be in.
enum HousesStatus {
  initial,
  loading,
  loaded,
  failure,
}

/// Represents the state of post-related operations.
final class HousesState extends Equatable {
  /// Private constructor for creating [HousesState] instances.
  const HousesState._({
    this.status = HousesStatus.initial,
    this.houses = Houses.empty,
    this.housesList = const [],
    this.failure = HousesFailure.empty,
  });

  /// Creates an initial [HousesState].
  const HousesState.initial() : this._();

  final HousesStatus status;
  final Houses houses;
  final List<Houses> housesList;
  final HousesFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        houses,
        housesList,
        failure,
      ];

  /// Creates a new [HousesState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  HousesState copyWith({
    HousesStatus? status,
    Houses? houses,
    List<Houses>? housesList,
    HousesFailure? failure,
  }) {
    return HousesState._(
      status: status ?? this.status,
      houses: houses ?? this.houses,
      housesList: housesList ?? this.housesList,
      failure: failure ?? this.failure,
    );
  }
}

/// Extension methods for convenient state checks.
extension HousesStateExtensions on HousesState {
  bool get isLoaded => status == HousesStatus.loaded;
  bool get isLoading => status == HousesStatus.loading;
  bool get isFailure => status == HousesStatus.failure;
}

/// Extension methods for creating new [HousesState] instances.
extension _HousesStateExtensions on HousesState {
  HousesState fromLoading() => copyWith(status: HousesStatus.loading);
  HousesState fromLoaded() => copyWith(status: HousesStatus.loaded);
  HousesState fromHousesLoaded({required Houses houses}) => copyWith(
        status: HousesStatus.loaded,
        houses: houses,
      );
  HousesState fromHousesListLoaded({required List<Houses> housesList}) =>
      copyWith(
        status: HousesStatus.loaded,
        housesList: housesList,
      );

  HousesState fromHousesFailure(HousesFailure failure) => copyWith(
        status: HousesStatus.failure,
        failure: failure,
      );
}
