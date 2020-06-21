import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';

class UserDataRepository {
  final userApiProvider =  UserDataProviderApiClient();

  Future<UserDataModel> fetchUser(uid) =>userApiProvider.getUser(uid);
  Future<UserDataModel> createUser(uid,userData) => userApiProvider.createUser(uid, userData);
  Future<Map<String, dynamic>> updatuser(uid,updateData) => userApiProvider.updateuser(uid, updateData);
}