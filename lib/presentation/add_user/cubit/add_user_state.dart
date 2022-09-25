abstract class AddUserState {}

class AddUserInitial extends AddUserState {}

class AddUserChangeProfileImageState extends AddUserState {}

class AddUserChangeVisiblePasswordState extends AddUserState {}

class AddUserLoadingState extends AddUserState {}

class AddUserSuccessState extends AddUserState {}

class AddUserFailureState extends AddUserState {}
