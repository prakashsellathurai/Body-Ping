import 'package:gkfit/model/userDataModel.dart';

class UserDataProviderApiResponse {
  String description;
  String status;
  UserDataModel user_data;

  UserDataProviderApiResponse({this.status, this.description, this.user_data});

  UserDataProviderApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user_data = json['user_data'];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_data'] = this.user_data;
    data["description"] = this.description;
    return data;
  }
}
