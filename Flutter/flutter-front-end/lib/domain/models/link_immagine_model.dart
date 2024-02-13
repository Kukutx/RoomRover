class LinkImmagine {
  final String link;

  LinkImmagine({
    required this.link,
  });

  factory LinkImmagine.fromJson(Map<String, dynamic> map) {
    return LinkImmagine(
      link: map['link'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'link': link,
    };
  }
}