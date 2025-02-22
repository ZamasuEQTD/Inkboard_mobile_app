
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/presentation/utils/extensions/breakpoints_extensions.dart';
import 'package:inkboard/features/hilos/presentation/pages/hilo_page.dart';

class ResponsiveLayoutDialog extends StatelessWidget {
  final Widget child;

  final String? title;

  const ResponsiveLayoutDialog({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Widget child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [DialogTitle(title: title), Flexible(child: this.child)],
        ).paddingOnly(bottom: 10);

        if (context.isLargerThanMd) {
          return LargerThanMdDialog(child: child);
        }

        return Dialog.fullscreen(child: child);
      },
    );
  }
}

class LargerThanMdDialog extends StatelessWidget {
  final Widget child;

  const LargerThanMdDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(width: 600, child: child),
      ),
    );
  }
}

class DialogTitle extends StatelessWidget {
  final String? title;

  const DialogTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.chevron_left_sharp, size: 30, color: Colors.black),
      ),
      title:
          title != null
              ? Text(
                title!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
              : null,
    );
  }
}
