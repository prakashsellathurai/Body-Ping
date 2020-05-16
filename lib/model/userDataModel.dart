class UserDataModel {
  String uid;
  String email;
  String photoUrl;
  String displayName;
  String phoneNumber;
  String phoneIsoCode;
  String gender;
  String dateofbirth;
  String currentPlan;

  UserDataModel(
      {this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.phoneNumber,
      this.currentPlan});

  UserDataModel.fromJson(Map<String, dynamic> userDetailsResponseJson) {
    uid = userDetailsResponseJson["uid"] ?? '';
    email = userDetailsResponseJson["email"] ?? '';
    photoUrl = userDetailsResponseJson["photoUrl"] ?? '';
    displayName = userDetailsResponseJson["displayName"] ?? '';
    phoneNumber = userDetailsResponseJson["phoneNumber"] ?? '';
    phoneIsoCode = userDetailsResponseJson["phoneIsoCode"] ?? '';
    gender = userDetailsResponseJson["gender"] ?? '';
    currentPlan = userDetailsResponseJson["currentPlan"] ?? 'free';
    dateofbirth = userDetailsResponseJson["dateofbirth"] ?? '';
  }

  get toJson {
    return {
      'uid': this.uid,
      'email': this.email,
      'photoUrl': this.photoUrl ?? '',
      'displayName': this.displayName ?? '',
      'phoneNumber': this.phoneNumber ?? '',
      'phoneIsoCode' : this.phoneIsoCode ?? '',
      'gender' :this.gender?? '',
      'dateofbirth' : this.dateofbirth ?? '',
      'currentPlan': this.currentPlan ?? 'free'
    };
  }
}
