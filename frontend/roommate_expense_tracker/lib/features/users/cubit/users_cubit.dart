import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:users_repository/users_repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  /// Creates a new instance of [UsersCubit].
  ///
  /// Requires a [UsersRepository] to handle data operations.
  UsersCubit({
    required UsersRepository usersRepository,
  })  : _usersRepository = usersRepository,
        super(const UsersState.initial());

  final UsersRepository _usersRepository;

  /// Insert [HouseMembers] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [HouseMembers].
  ///
  /// Requires the [userId] to create the object
  /// Requires the [houseId] to create the object
  /// Requires the [isAdmin] to create the object
  /// Requires the [isActive] to create the object
  Future<void> createHouseMembers({
    required String userId,
    required String houseId,
    required String isAdmin,
    required String isActive,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembers = await _usersRepository.createHouseMembers(
        userId: userId,
        houseId: houseId,
        isAdmin: isAdmin,
        isActive: isActive,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersLoaded(
          houseMembers: houseMembers,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all [Users] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllUsers({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final usersList = await _usersRepository.fetchAllUsers(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromUsersListLoaded(
          usersList: usersList,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create users: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch single() [Users] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Users].
  ///
  /// Requires the [userId] for lookup
  Future<void> fetchUsersWithUserId({
    required String userId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final users = await _usersRepository.fetchUsersWithUserId(
        userId: userId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromUsersLoaded(
          users: users,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create users: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch single() [Users] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Users].
  ///
  /// Requires the [email] for lookup
  Future<void> fetchUsersWithEmail({
    required String email,
    required String token,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final users = await _usersRepository.fetchUsersWithEmail(
        email: email,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromUsersLoaded(
          users: users,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create users: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllHouseMembers({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembersList = await _usersRepository.fetchAllHouseMembers(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersListLoaded(
          houseMembersList: houseMembersList,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseMemberId] for lookup
  Future<void> fetchHouseMembersWithHouseMemberId({
    required String houseMemberId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembers =
          await _usersRepository.fetchHouseMembersWithHouseMemberId(
        houseMemberId: houseMemberId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersLoaded(
          houseMembers: houseMembers,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Requires the [userId] for lookup
  Future<void> fetchAllHouseMembersWithUserId({
    required String userId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembersList =
          await _usersRepository.fetchAllHouseMembersWithUserId(
        userId: userId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersListLoaded(
          houseMembersList: houseMembersList,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<void> fetchAllHouseMembersWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembersList =
          await _usersRepository.fetchAllHouseMembersWithHouseId(
        houseId: houseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersListLoaded(
          houseMembersList: houseMembersList,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [userId] for lookup
  Future<void> fetchHouseMembersWithUserId({
    required String userId,
    required String token,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembers = await _usersRepository.fetchHouseMembersWithUserId(
        userId: userId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersLoaded(
          houseMembers: houseMembers,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseId] for lookup
  Future<void> fetchHouseMembersWithHouseId({
    required String houseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembers = await _usersRepository.fetchHouseMembersWithHouseId(
        houseId: houseId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersLoaded(
          houseMembers: houseMembers,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Update the given [Users] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Users].
  ///
  /// Requires the [userId] to update the object
  Future<void> updateUsers({
    required String userId,
    required Users newUsersData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final users = await _usersRepository.updateUsers(
        userId: userId,
        newUsersData: newUsersData,
        token: token,
      );
      emit(
        state.fromUsersLoaded(
          users: users,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create users: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Update the given [HouseMembers] in Rds.
  ///
  /// Return data if successful, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseMemberId] to update the object
  Future<void> updateHouseMembers({
    required String houseMemberId,
    required HouseMembers newHouseMembersData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final houseMembers = await _usersRepository.updateHouseMembers(
        houseMemberId: houseMemberId,
        newHouseMembersData: newHouseMembersData,
        token: token,
      );
      emit(
        state.fromHouseMembersLoaded(
          houseMembers: houseMembers,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Delete the given [Users] from Rds.
  ///
  /// Requires the [userId] to delete the object
  Future<void> deleteUsers({
    required String userId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _usersRepository.deleteUsers(
        userId: userId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create users: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Delete the given [HouseMembers] from Rds.
  ///
  /// Requires the [houseMemberId] to delete the object
  Future<void> deleteHouseMembers({
    required String houseMemberId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _usersRepository.deleteHouseMembers(
        houseMemberId: houseMemberId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Requires the [userId] for lookup
  Future<void> fetchUsersHouseData({
    required String userId,
    required String token,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final userHouseDataList = await _usersRepository.fetchUserHouseData(
        userId: userId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(state.fromUserHouseDataListLoaded(
        userHouseDataList: userHouseDataList,
      ));
    } on UsersFailure catch (failure) {
      debugPrint('Failure to create houseMembers: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }

  /// Fetch list of all photo URLs of house members for a given houseId from Rds.
  ///
  /// Requires the [houseId] for lookup.
  Future<void> fetchAllHouseMembersPhotoUrls({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      final photoUrlsList =
          await _usersRepository.fetchAllHouseMembersPhotoUrls(
        houseId: houseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromHouseMembersPhotoUrlsLoaded(
          photoUrlsList: photoUrlsList,
        ),
      );
    } on UsersFailure catch (failure) {
      debugPrint('Failure to fetch house members photo URLs: $failure');
      emit(state.fromUsersFailure(failure));
    }
  }
}
