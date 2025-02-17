import 'dart:collection';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/media/domain/ifile_picker_service.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:mime/mime.dart';

class FilePickerService extends IFilePickerService {
  static final picker = FilePicker.platform;
  @override
  Future<List<PickedFile>> pick({int cantidad = 1}) async {
    log("seleccionadn");
    var files = await picker.pickFiles();
    log("message");
    List<PickedFile> picked = [];

    if (files == null) {
      return picked;
    }

    for (final PlatformFile file in files.files) {
      final String mime = lookupMimeType(file.path!)!.split("/")[0];

      PickedFileProvider? provider =
          PickedFileProvider.values.firstWhereOrNull((p) => p.name == mime);

      provider ??= PickedFileProvider.other;

      picked.add(PickedFile(source: file.path!, provider: provider));
    }

    return picked;
  }

  @override
  Future<PickedFile?> pickOne() async => (await pick()).firstOrNull;
}
