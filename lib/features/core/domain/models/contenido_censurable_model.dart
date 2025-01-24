class ContenidoCensurableModel<T> {
  final bool spoiler;
  final T content;
  bool get esSpoiler => spoiler;

  const ContenidoCensurableModel(this.spoiler, this.content);

  ContenidoCensurableModel<T> copyWith({
    bool? spoiler,
    T? content,
  }) {
    return ContenidoCensurableModel(
      spoiler ?? this.spoiler,
      content ?? this.content,
    );
  }

  factory ContenidoCensurableModel.fromJson(Map<String, dynamic> json) {
    return ContenidoCensurableModel(json["spoiler"], json["content"]);
  }
}