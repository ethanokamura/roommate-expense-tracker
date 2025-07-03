part of 'users_cubit.dart';

/// Represents the different states a post can be in.
enum UsersStatus {
  initial,
  loading,
  loaded,
  failure,
}

/// Represents the state of post-related operations.
final class UsersState extends Equatable {
  /// Private constructor for creating [UsersState] instances.
  const UsersState._({
    this.status = UsersStatus.initial,
    this.users = Users.empty,
    this.usersList = const [],
    this.houseMembers = HouseMembers.empty,
    this.houseMembersList = const [],
    this.failure = UsersFailure.empty,
  });

  /// Creates an initial [UsersState].
  const UsersState.initial() : this._();

  final UsersStatus status;
  final Users users;
  final List<Users> usersList;
  final HouseMembers houseMembers;
  final List<HouseMembers> houseMembersList;
  final UsersFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        users,
        usersList,
        houseMembers,
        houseMembersList,
        failure,
      ];

  /// Creates a new [UsersState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  UsersState copyWith({
    UsersStatus? status,
    Users? users,
    List<Users>? usersList,
    HouseMembers? houseMembers,
    List<HouseMembers>? houseMembersList,
    UsersFailure? failure,
  }) {
    return UsersState._(
      status: status ?? this.status,
      users: users ?? this.users,
      usersList: usersList ?? this.usersList,
      houseMembers: houseMembers ?? this.houseMembers,
      houseMembersList: houseMembersList ?? this.houseMembersList,
      failure: failure ?? this.failure,
    );
  }
}

/// Extension methods for convenient state checks.
extension UsersStateExtensions on UsersState {
  bool get isLoaded => status == UsersStatus.loaded;
  bool get isLoading => status == UsersStatus.loading;
  bool get isFailure => status == UsersStatus.failure;
}

/// Extension methods for creating new [UsersState] instances.
extension _UsersStateExtensions on UsersState {
  UsersState fromLoading() => copyWith(status: UsersStatus.loading);
  UsersState fromLoaded() => copyWith(status: UsersStatus.loaded);
  UsersState fromUsersLoaded({required Users users}) => copyWith(
        status: UsersStatus.loaded,
        users: users,
      );
  UsersState fromUsersListLoaded({required List<Users> usersList}) => copyWith(
        status: UsersStatus.loaded,
        usersList: usersList,
      );
  UsersState fromHouseMembersLoaded({required HouseMembers houseMembers}) =>
      copyWith(
        status: UsersStatus.loaded,
        houseMembers: houseMembers,
      );
  UsersState fromHouseMembersListLoaded(
          {required List<HouseMembers> houseMembersList}) =>
      copyWith(
        status: UsersStatus.loaded,
        houseMembersList: houseMembersList,
      );

  UsersState fromUsersFailure(UsersFailure failure) => copyWith(
        status: UsersStatus.failure,
        failure: failure,
      );
}
