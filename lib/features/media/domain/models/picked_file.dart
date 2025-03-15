import 'package:equatable/equatable.dart';
import 'package:inkboard/features/media/domain/models/media.dart';

class PickedFile extends Equatable {
  final String source;

  final MediaProvider provider;

  final String contentType;

  final bool spoiler;
  const PickedFile({
    required this.source,
    required this.provider,
    required this.contentType,
    this.spoiler = false,
  });

  PickedFile copyWith({
    String? source,
    MediaProvider? provider,
    String? contentType,
    bool? spoiler,
  }) {
    return PickedFile(
      source: source ?? this.source,
      provider: provider ?? this.provider,
      contentType: contentType ?? this.contentType,
      spoiler: spoiler ?? this.spoiler,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [source];
}
