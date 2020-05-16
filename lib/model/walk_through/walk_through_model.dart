class PageModel {
  final String assetImagePath;
  final String text;
  PageModel({this.assetImagePath, this.text});
}

List<PageModel> pages = [
  PageModel(
    assetImagePath: 'assets/images/walk_through/First.png',
    text: 'Want to build Stamina and get better healthy life ',
  ),
  PageModel(
    assetImagePath: 'assets/images/walk_through/Middle.png',
    text: 'Revitalize your training to home based workouts',
  ),
  PageModel(
      assetImagePath: 'assets/images/walk_through/Third.png',
      text: 'We are here to get you fit'),
];
