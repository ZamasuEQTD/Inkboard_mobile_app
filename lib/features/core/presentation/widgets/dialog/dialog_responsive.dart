import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/presentation/utils/extensions/breakpoints_extensions.dart';

class DialogStyle {
  final double? width;
  final double? height;

  const DialogStyle({this.width, this.height});
}

enum SmTarget { fullscreen, bottomsheet }

class ResponsiveLayoutDialog extends StatelessWidget {
  final Widget child;

  final SmTarget smTarget;

  final String? title;
  final DialogStyle? style;
  final bool showAppbar;

  const ResponsiveLayoutDialog({
    super.key,
    required this.child,
    this.smTarget = SmTarget.fullscreen,
    this.showAppbar = true,
    this.title,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Widget child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAppbar) DialogTitle(title: title),
            Flexible(child: this.child),
          ],
        ).paddingOnly(bottom: 10);

        if (context.isLargerThanMd) {
          return LargerThanMdDialog(dialogStyle: style, child: child);
        }
        if (smTarget == SmTarget.bottomsheet) {
          return BottomSheet(
            onClosing: () {},
            enableDrag: false,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
            builder: (context) => this.child.paddingOnly(top: 10),
          );
        }

        return Dialog.fullscreen(child: child);
      },
    );
  }  
}

class LargerThanMdDialog extends StatelessWidget {
  final Widget child;

  final DialogStyle? dialogStyle;

  const LargerThanMdDialog({super.key, required this.child, this.dialogStyle});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(width: dialogStyle?.width ?? 600, child: child),
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
        icon: Icon(Icons.chevron_left_sharp, size: 30),
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
