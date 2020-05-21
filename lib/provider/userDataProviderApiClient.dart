import 'dart:convert';

import 'package:gkfit/constants/constants.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/model/userDataProviderApiResponseModel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http show Client;

String APi_HOST = Constants.userDataApiURL;

abstract class UserDataProviderApiClientAbstract {
  Future<UserDataModel> getUser(String uid);
  Future<UserDataModel> createUser(String uid, Map<String, dynamic> user_data);
  Future<Map<String, dynamic>> updateuser(String uid, Map<String, dynamic> updateData);
}

class UserDataProviderApiClient implements UserDataProviderApiClientAbstract {
  http.Client client = http.Client();
  @override
  Future<UserDataModel> createUser(
      String uid, Map<String, dynamic> userData) async {
    String createUserUrl = APi_HOST + "/users/" + uid + "/create";
    print(userData);
    final response = await client.post(createUserUrl, body: userData);
    if (response.statusCode == 200) {
      return UserDataModel.fromJson(json.decode(response.body));
    } else {
      throw PlatformException(
          code: 'SERVER_ERROR', message: 'error while creating user');
    }
  }

  @override
  Future<UserDataModel> getUser(String uid) async {
    String getUserUrl = APi_HOST + "/users/" + uid;
    try {
      final response = await client.get(getUserUrl);
      if (response.statusCode == 200) {
        if (json.decode(response.body)['status'] == "error"){
           return UserDataModel.fromJson({});
        }
        return UserDataModel.fromJson(json.decode(response.body)['user_data']);
      } else {
        throw PlatformException(
            code: 'SERVER_ERROR', message: 'error while fetching user');
      }
    } catch (e) {
      print(e);
      throw PlatformException(
          code: 'SERVER_ERROR', message: 'error while fetching user');
    }
  }

  @override
  Future<Map<String,dynamic>> updateuser(
      String uid, Map<String, dynamic> updateData) async {
    String updateUserUrl = APi_HOST + "/users/" + uid + "/update";
    final response = await client.post(updateUserUrl, body: updateData);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw PlatformException(
          code: 'SERVER_ERROR', message: 'error while creating user');
    }
  }
}
