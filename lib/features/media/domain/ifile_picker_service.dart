import 'package:inkboard/features/media/domain/models/picked_file.dart';

abstract class IFilePickerService {
  Future<List<PickedFile>> pick({int cantidad = 1});

  Future<PickedFile?> pickOne();
}
