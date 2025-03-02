import 'package:inkboard/features/media/presentation/logic/video_provider.dart';
import 'package:video_player/video_player.dart';

extension VideoProviderExtensions on VideoProvider {
  VideoPlayerController toController() {
    if (this is NetworkVideoProvider) {
      return VideoPlayerController.networkUrl(Uri.parse((this as NetworkVideoProvider).url));
    }

    return VideoPlayerController.file((this as FileVideoProvider).file);
  }
}