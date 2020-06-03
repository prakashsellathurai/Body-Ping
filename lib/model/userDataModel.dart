class UserDataModel {
  String uid;
  String email;
  String photoUrl;
  String firstName,lastName;
  String phoneNumber;
  String phoneIsoCode;
  String gender;
  String dateofbirth;
  String currentPlan;

  UserDataModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.phoneNumber,
      this.currentPlan});

  UserDataModel.fromJson(Map<String, dynamic> userDetailsResponseJson) {
    uid = userDetailsResponseJson["uid"] ?? '';
    email = userDetailsResponseJson["email"] ?? '';

    firstName = userDetailsResponseJson["firstName"] ?? '';
    lastName = userDetailsResponseJson["lastName"] ?? '';

    photoUrl = userDetailsResponseJson["photoUrl"] ?? '';
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
      'firstName': this.firstName ?? '',
      'lastName': this.lastName ?? '',
      'phoneNumber': this.phoneNumber ?? '',
      'phoneIsoCode' : this.phoneIsoCode ?? '',
      'gender' :this.gender?? '',
      'dateofbirth' : this.dateofbirth ?? '',
      'currentPlan': this.currentPlan ?? 'free'
    };
  }
}
