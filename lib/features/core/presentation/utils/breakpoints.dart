import 'package:responsive_framework/responsive_framework.dart';

class Breakpoints {

  const Breakpoints._();

  static const Breakpoint  sm = Breakpoint(start: 0,end: 639, name: "sm");
  static const Breakpoint  md = Breakpoint(start: 640,end: 767, name: "md");
  static const Breakpoint  lg = Breakpoint(start: 768,end: 1023, name: "lg");
  static const Breakpoint  xl = Breakpoint(start: 1024,end: 1279, name: "xl");
  static const Breakpoint  xxl = Breakpoint(start: 1280,end: double.infinity, name: "xxl");

  static List<Breakpoint> breakpoints = [
    sm,
    md,
    lg,
    xl,
    xxl
  ];
}