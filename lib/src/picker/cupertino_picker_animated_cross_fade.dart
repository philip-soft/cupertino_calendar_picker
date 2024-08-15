import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPickerAnimatedCrossFade extends StatelessWidget {
  const CupertinoPickerAnimatedCrossFade({
    required this.firstChild,
    required this.crossFadeState,
    this.secondChild,
    super.key,
  });

  final Widget firstChild;
  final Widget? secondChild;
  final CrossFadeState crossFadeState;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: pickerFadeDuration,
      firstChild: firstChild,
      secondChild: secondChild ?? const SizedBox(),
      crossFadeState: crossFadeState,
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          children: <Widget>[
            SizedBox(
              key: bottomChildKey,
              child: bottomChild,
            ),
            SizedBox(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}
