import 'package:customer_app/model/userDataModel.dart';
import 'package:customer_app/repository/userDataRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UserEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserFetch extends UserEvent {}

class UserState {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserUnitialized extends UserState {}

class UserFetchError extends UserState {}

class UserDataFetched extends UserState {
  final UserDataModel userData;
  UserDataFetched({this.userData});

  UserDataFetched copyWith({UserDataModel userData}) {
    return UserDataFetched(userData: userData);
  }
    @override
  List<Object> get props => [userData];

  @override
  String toString() => '${userData.toJson}';
  @override
  UserDataModel getUserData() => userData;
  @override
  String uid() => userData.uid;
  @override
  String displayName() => userData.displayName;

}

class UserBloc extends Bloc<UserEvent,UserState>{
  String uid;
  UserBloc({this.uid});

  final _userRepository = UserRepository();
  final _userFetcher = PublishSubject<UserDataModel>();

  Stream<UserDataModel> get userData => _userFetcher.stream;

  getUser() async{
    return await _userFetcher.last;
  }

  fetchUser() async {
    UserDataModel userData = await _userRepository.fetchUser(this.uid);
    print("fetching user");
    _userFetcher.sink.add(userData);
  }

  dispose() {
    _userFetcher.close();
  }

  @override
  // TODO: implement initialState
  UserState get initialState => UserUnitialized();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    final currentState = state;
    try {
      if (currentState is UserUnitialized){
         UserDataModel userData = await _userRepository.fetchUser(this.uid);
         yield UserDataFetched(userData: userData);
      }

      if (currentState is UserDataFetched){
          UserDataModel userData = await _userRepository.fetchUser(this.uid);
         yield currentState.copyWith(userData: userData);
      }
      if (currentState is UserFetchError) {
        throw Exception("user fetch error");
      }
    } catch (e) {
    }
   
  }
}
