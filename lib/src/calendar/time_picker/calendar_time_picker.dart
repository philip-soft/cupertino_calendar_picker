import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarTimePicker extends StatelessWidget {
  const CalendarTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Divider(
            height: 0.0,
            color: CupertinoColors.separator.resolveFrom(context),
            thickness: 0.2,
          ),
        ),
        const SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            const SizedBox(width: 16.0),
            const Spacer(),
            Container(
              height: 34.0,
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(6.0),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Text(
                '8:00',
                style: TextStyle(
                  color: CupertinoColors.label.resolveFrom(context),
                  fontSize: 17.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            CupertinoSlidingSegmentedControl<int>(
              onValueChanged: (_) {},
              groupValue: 0,
              children: <int, Widget>{
                0: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Center(
                    child: Text(
                      CupertinoLocalizations.of(context)
                          .anteMeridiemAbbreviation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                1: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Center(
                    child: Text(
                      CupertinoLocalizations.of(context)
                          .postMeridiemAbbreviation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              },
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        const SizedBox(height: 7.0),
      ],
    );
  }
}
