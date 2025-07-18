import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:houses_repository/houses_repository.dart';

part 'houses_state.dart';

class HousesCubit extends Cubit<HousesState> {
  /// Creates a new instance of [HousesCubit].
  ///
  /// Requires a [HousesRepository] to handle data operations.
  HousesCubit({
    required HousesRepository housesRepository,
  })  : _housesRepository = housesRepository,
        super(const HousesState.initial());

  final HousesRepository _housesRepository;

  /// Insert [Houses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Houses].
  ///
  /// Requires the [name] to create the object
  Future<void> createHouses({
    required String name,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houses = await _housesRepository.createHouses(
        name: name,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHousesLoaded(
          houses: houses,
        ),
      );
    } on HousesFailure catch (failure) {
      debugPrint('Failure to create houses: $failure');
      emit(state.fromHousesFailure(failure));
    }
  }

  /// Fetch list of all [Houses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllHouses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final housesList = await _housesRepository.fetchAllHouses(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHousesListLoaded(
          housesList: housesList,
        ),
      );
    } on HousesFailure catch (failure) {
      debugPrint('Failure to create houses: $failure');
      emit(state.fromHousesFailure(failure));
    }
  }

  /// Fetch single() [Houses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Houses].
  ///
  /// Requires the [houseId] for lookup
  Future<void> fetchHousesWithHouseId({
    required String houseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houses = await _housesRepository.fetchHousesWithHouseId(
        houseId: houseId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHousesLoaded(
          houses: houses,
        ),
      );
    } on HousesFailure catch (failure) {
      debugPrint('Failure to create houses: $failure');
      emit(state.fromHousesFailure(failure));
    }
  }

  /// Update the given [Houses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Houses].
  ///
  /// Requires the [houseId] to update the object
  Future<void> updateHouses({
    required String houseId,
    required Houses newHousesData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houses = await _housesRepository.updateHouses(
        houseId: houseId,
        newHousesData: newHousesData,
        token: token,
      );
      emit(
        state.fromHousesLoaded(
          houses: houses,
        ),
      );
    } on HousesFailure catch (failure) {
      debugPrint('Failure to create houses: $failure');
      emit(state.fromHousesFailure(failure));
    }
  }

  /// Delete the given [Houses] from Rds.
  ///
  /// Requires the [houseId] to delete the object
  Future<void> deleteHouses({
    required String houseId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _housesRepository.deleteHouses(
        houseId: houseId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on HousesFailure catch (failure) {
      debugPrint('Failure to create houses: $failure');
      emit(state.fromHousesFailure(failure));
    }
  }
}
