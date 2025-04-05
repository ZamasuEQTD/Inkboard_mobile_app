import 'package:get/get.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

class AppFailureController extends GetxController  {
  final Rx<Failure?> failure = Rx(null);

  void limpiar()=> failure.value = null;

  void setFailure(Failure failure)=> this.failure.value = failure;
}