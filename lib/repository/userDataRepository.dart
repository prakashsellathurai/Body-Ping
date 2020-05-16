import 'package:customer_app/model/userDataModel.dart';
import 'package:customer_app/provider/userDataProviderApiClient.dart';

class UserRepository {
  final userApiProvider =  UserDataProviderApiClient();

  Future<UserDataModel> fetchUser(uid) =>userApiProvider.getUser(uid);
  Future<UserDataModel> createUser(uid,userData) => userApiProvider.createUser(uid, userData);
  Future<Map<String, dynamic>> updatuser(uid,updateData) => userApiProvider.updateuser(uid, updateData);
}