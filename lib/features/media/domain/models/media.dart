class MediaSource {
  final MediaSourceType source;
  final MediaModel model;

  const MediaSource({required this.source, required this.model});
}

enum MediaSourceType { file, network }

class MediaModel {
  final MediaProvider provider;
  final String url;
  final String? previsualizacion;

  const MediaModel({
    required this.provider,
    required this.url,
    this.previsualizacion,
  });

  MediaModel copyWith({
    MediaProvider? provider,
    bool? spoiler,
    String? url,
    String? previsualizacion,
  }) {
    return MediaModel(
      provider: provider ?? this.provider,
      url: url ?? this.url,
      previsualizacion: previsualizacion ?? this.previsualizacion,
    );
  }

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      provider: MediaProvider.values.firstWhere(
        (e) => e.name == json['provider'].toString().toLowerCase(),
      ),
      url: json['url'],
      previsualizacion: json['previsualizacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'url': url,
      'previsualizacion': previsualizacion,
    };
  }
}

enum MediaProvider { video, image,gif, youtube, other }
