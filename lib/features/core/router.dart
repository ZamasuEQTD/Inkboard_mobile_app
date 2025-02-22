import 'package:get/get.dart';
import 'package:inkboard/features/hilos/presentation/pages/hilo_page.dart';
import 'package:inkboard/features/home/presentation/pages/home_page.dart';

var routes = [
  GetPage(name: '/', page: () => HomePage()),
  GetPage(name: '/hilo/:id', page: () => HiloPage()),
];
