import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inkboard/features/core/presentation/utils/breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HiloPage extends StatelessWidget {
  const HiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (ResponsiveBreakpoints.of(context)
              .largerThan(Breakpoints.sm.name!)) {
            //no celular
            return LayoutBuilder(
              builder: (context, constraints) {
                return Row(children: [
                  SizedBox(
                    width: 0.45 * constraints.maxWidth,
                    height: double.infinity,
                    child: CustomScrollView(
                      slivers: [],
                    ),
                  ),
                  ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(
                        width: 0.55 * constraints.maxWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomScrollView(
                              shrinkWrap: true,
                              slivers: [
                                SliverMainAxisGroup(slivers: []),
                              ],
                            ),
                            ColoredBox(
                              color: Colors.green,
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                              ),
                            ),
                          ],
                        )),
                  )
                ]);
              },
            );
          }
          //celular
          return Column(
            children: [],
          );
        },
      ),
    );
  }
}
