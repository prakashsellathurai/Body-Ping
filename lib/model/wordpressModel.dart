class SinglePost {
  final String featuredImage, title, date, url, content, avatarURL, authorName;

  var id;

  var excerpt;

  SinglePost({
    this.id,
    this.authorName,
    this.content,
    this.avatarURL,
    this.featuredImage,
    this.title,
    this.date,
    this.url,
    this.excerpt,
  });

  factory SinglePost.fromJSON(Map<String, dynamic> json) {
    return SinglePost(
        id: json['id'],
        title: json['title']['rendered'],
        content: json['content']['rendered'],
        date: json['date'] != null
            ? json['date'].toString().replaceFirst('T', ' ')
            : null,
        featuredImage: json['_links']['wp:featuredmedia'] != null
            ? !json['_links']['wp:featuredmedia'][0]['embeddable']
                ? (json['_links']['wp:featuredmedia'][0]['href'])
                : json["jetpack_featured_media_url"]
            : null,
        excerpt: json['excerpt']['rendered'],
        authorName: json['author'].toString());
  }
  factory SinglePost.fromEndErrorHandler(Map<String, dynamic> json) {
    return SinglePost(
        featuredImage: json['featuredImage'], title: json['title']);
  }
}
