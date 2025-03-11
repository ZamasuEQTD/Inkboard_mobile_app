import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/media/domain/ifile_picker_service.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:mime/mime.dart';

class FilePickerService extends IFilePickerService {
  static final picker = FilePicker.platform;
  @override
  Future<List<PickedFile>> pick({int cantidad = 1}) async {
    var files = await picker.pickFiles();

    List<PickedFile> picked = [];

    if (files == null) {
      return picked;
    }

    for (final PlatformFile file in files.files) {
      final String mime = lookupMimeType(file.path!)!.split("/")[0];

      MediaProvider? provider = MediaProvider.values.firstWhereOrNull(
        (p) => p.name == mime.toLowerCase(),
      );

      provider ??= MediaProvider.other;

      picked.add(
        PickedFile(
          source: file.path!,
          provider: provider,
          contentType: lookupMimeType(file.path!)!,
        ),
      );
    }

    return picked;
  }

  @override
  Future<PickedFile?> pickOne() async => (await pick()).firstOrNull;
}
